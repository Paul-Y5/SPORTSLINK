import 'package:flutter/material.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/screens/campo_details.dart';

class CardCampo extends StatelessWidget {
  final Campo campo;

  const CardCampo({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          campo.nome,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Localização: ${campo.ponto.latitude.toStringAsFixed(4)}, ${campo.ponto.longitude.toStringAsFixed(4)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            if (campo is CampoPub)
              Text(
                'Entidade: ${(campo as CampoPub).entidadePublicaResp}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )
            else if (campo is CampoPriv)
              Text(
                'Proprietário: ${getMyUser((campo as CampoPriv).idArrendador).nome}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.orange,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CampoDetails(campo: campo),
              ),
            );
          },
        ),
      ),
    );
  }
}
