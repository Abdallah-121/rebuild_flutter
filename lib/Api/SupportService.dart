import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Model/SupportMessageModel.dart';
import 'package:rebuild/Model/SupportTicketModel.dart';

class SupportService {
  final String baseUrl;
  final AuthService authService;

  SupportService({required this.baseUrl, required this.authService});

  Future<Map<String, String>> _headers() async {
    final token = await authService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<SupportTicket> getTicket(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/SupportTicket/$id'),
      headers: await _headers(),
    );
    return SupportTicket.fromJson(json.decode(res.body));
  }

  Future<List<SupportTicket>> getMyTickets() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/SupportTicket/my-tickets'),
      headers: await _headers(),
    );

    final body = json.decode(res.body) as List;
    return body.map((e) => SupportTicket.fromJson(e)).toList();
  }

  Future<List<SupportMessage>> getMessages(int ticketId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/SupportMessage/ticket/$ticketId'),
      headers: await _headers(),
    );
    final body = json.decode(res.body) as List;
    return body.map((e) => SupportMessage.fromJson(e)).toList();
  }

  Future<SupportTicket> createTicket(String title, int cityId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/SupportTicket'),
      headers: await _headers(),
      body: json.encode({"title": title, "cityId": cityId}),
    );
    return SupportTicket.fromJson(json.decode(res.body));
  }

  Future<SupportMessage> sendMessage(int ticketId, String msg) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/SupportMessage'),
      headers: await _headers(),
      body: json.encode({"ticketId": ticketId, "message": msg}),
    );
    return SupportMessage.fromJson(json.decode(res.body));
  }
}
