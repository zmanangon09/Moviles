import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import '../models/correo_model.dart';

class CorreoViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      GmailApi.gmailReadonlyScope,
      GmailApi.gmailModifyScope,
      GmailApi.gmailSendScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  List<Correo> _correos = [];
  String _searchQuery = '';
  bool _isLoading = false;

  String get searchQuery => _searchQuery;
  GoogleSignInAccount? get currentUser => _currentUser;
  List<Correo> get correos => _correos.where((c) =>
    c.remitente.toLowerCase().contains(_searchQuery.toLowerCase()) || 
    c.asunto.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();
  bool get isLoading => _isLoading;
  int get noLeidos => _correos.where((c) => c.noLeido).length;

  CorreoViewModel() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      _currentUser = account;
      if (_currentUser != null) {
        fetchEmails();
      }
      notifyListeners();
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error en inicio de sesión: $error');
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchEmails() async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) return;

      final gmailApi = GmailApi(httpClient);
      final messagesResponse = await gmailApi.users.messages.list('me', maxResults: 15);
      
      List<Correo> loadedCorreos = [];

      if (messagesResponse.messages != null) {
        for (var messageSummary in messagesResponse.messages!) {
          final message = await gmailApi.users.messages.get('me', messageSummary.id!);
          
          String remitente = 'Desconocido';
          String asunto = '(Sin asunto)';
          String fecha = '';
          bool noLeido = message.labelIds?.contains('UNREAD') ?? false;

          final headers = message.payload?.headers;
          if (headers != null) {
            for (var header in headers) {
              if (header.name == 'From') remitente = header.value ?? remitente;
              if (header.name == 'Subject') asunto = header.value ?? asunto;
              if (header.name == 'Date') fecha = header.value ?? fecha;
            }
          }

          // Extraer cuerpo del mensaje
          String cuerpo = _extraerCuerpo(message.payload);

          loadedCorreos.add(Correo(
            id: message.id!,
            remitente: remitente,
            asunto: asunto,
            cuerpo: cuerpo,
            fecha: fecha,
            noLeido: noLeido,
          ));
        }
      }

      _correos = loadedCorreos;
    } catch (error) {
      print('Error cargando correos: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _extraerCuerpo(MessagePart? payload) {
    if (payload == null) return '';
    
    // Si el cuerpo está directamente en el payload
    if (payload.body?.data != null) {
      return utf8.decode(base64Url.decode(payload.body!.data!));
    }

    // Si el mensaje es multiparte, buscar en las partes
    if (payload.parts != null) {
      for (var part in payload.parts!) {
        if (part.mimeType == 'text/plain' && part.body?.data != null) {
          return utf8.decode(base64Url.decode(part.body!.data!));
        }
        // Recursivo para partes anidadas
        String cuerpoParte = _extraerCuerpo(part);
        if (cuerpoParte.isNotEmpty) return cuerpoParte;
      }
    }
    
    return 'Sin contenido visible';
  }

  Future<void> marcarLeido(String id) async {
    if (_currentUser == null) return;

    try {
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) return;
      final gmailApi = GmailApi(httpClient);

      await gmailApi.users.messages.batchModify(
        BatchModifyMessagesRequest(
          ids: [id],
          removeLabelIds: ['UNREAD'],
        ),
        'me',
      );
      
      final index = _correos.indexWhere((c) => c.id == id);
      if (index != -1) {
        _correos[index].noLeido = false;
        notifyListeners();
      }
    } catch (error) {
      print('Error marcando como leído: $error');
    }
  }

  Future<bool> eliminarCorreo(String id) async {
    if (_currentUser == null) return false;

    try {
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) return false;
      final gmailApi = GmailApi(httpClient);

      await gmailApi.users.messages.trash('me', id);
      
      _correos.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (error) {
      print('Error al eliminar correo: $error');
      return false;
    }
  }

  Future<void> marcarTodosLeidos() async {
    if (_currentUser == null) return;

    try {
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) return;
      final gmailApi = GmailApi(httpClient);

      List<String> idsAModificar = _correos
          .where((c) => c.noLeido)
          .map((c) => c.id)
          .toList();

      if (idsAModificar.isEmpty) return;

      await gmailApi.users.messages.batchModify(
        BatchModifyMessagesRequest(
          ids: idsAModificar,
          removeLabelIds: ['UNREAD'],
        ),
        'me',
      );

      for (var correo in _correos) {
        correo.noLeido = false;
      }
      notifyListeners();
    } catch (error) {
      print('Error marcando todos como leídos: $error');
    }
  }

  Future<bool> sendEmail(String to, String subject, String body) async {
    if (_currentUser == null) return false;

    try {
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) return false;
      final gmailApi = GmailApi(httpClient);

      String rawMessage = 'To: $to\n'
          'Subject: $subject\n'
          'Content-Type: text/plain; charset="UTF-8"\n\n'
          '$body';

      final encodedMessage = base64UrlEncode(utf8.encode(rawMessage))
          .replaceAll('=', '');

      final message = Message(raw: encodedMessage);
      await gmailApi.users.messages.send(message, 'me');
      return true;
    } catch (error) {
      print('Error enviando correo: $error');
      return false;
    }
  }
}
