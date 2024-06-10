import 'dart:io';
import 'pelanggan.dart';

void main() {
  antrianPemasanganwifi queue = antrianPemasanganwifi();
  bool exit = false;

  List<String> pilihanMenu = [
    'Tambahkan pelanggan ke antrian',
    'Tampilkan antrian',
    'Cari daftar pelanggan',
    'Layani pelanggan berikutnya',
    'Batalkan pemasangan',
    'Keluar'
  ];

  while (!exit) {
    print('\nPilih Menu:');
    for (int i = 0; i < pilihanMenu.length; i++) {
      print('${i + 1}. ${pilihanMenu[i]}');
    }
    stdout.write('Masukkan pilihan Anda (1-${pilihanMenu.length}): ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Masukkan nama pelanggan: ');
        String name = stdin.readLineSync()!;
        stdout.write('Masukkan alamat pelanggan: ');
        String alamat = stdin.readLineSync()!;
        stdout.write('Masukkan Nomor Telepon: ');
        String nomor = stdin.readLineSync()!;
        queue.addToQueue(name, alamat, nomor);
        break;
      case '2':
        queue.displayQueue();
        break;
      case '3':
        stdout.write('Masukkan nama atau alamat pelanggan: ');
        String dataPelanggan = stdin.readLineSync()!;
        Pelanggan? result = queue.search(dataPelanggan);
        if (result != null) {
          print('Pelanggan ditemukan: $result');
        } else {
          print('Pelanggan tidak ditemukan.');
        }
        break;
      case '4':
        stdout.write('Apakah Anda yakin ingin melayani? (ya/tidak): ');
        String? response = stdin.readLineSync()!.toLowerCase();
        if (response == 'ya') queue.serveNextCustomer();
        break;
      case '5':
        stdout.write('Masukkan nama pelanggan yang ingin dibatalkan: ');
        String nama = stdin.readLineSync()!;
        stdout.write('Apakah Anda yakin ingin membatalkan? (ya/tidak): ');
        String? confirmCancel = stdin.readLineSync()!.toLowerCase();
        if (confirmCancel == 'ya') queue.batalkanPemasangan(nama);
        break;
      case '6':
        stdout.write('Apakah Anda yakin ingin keluar? (ya/tidak): ');
        String? response = stdin.readLineSync()!.toLowerCase();
        if (response == 'ya') {
          print('Terima kasih telah menggunakan program ini.');
          exit = true;
        }
        break;
      default:
        print('Pilihan tidak valid. Silakan coba lagi.');
        break;
    }
  }
}
