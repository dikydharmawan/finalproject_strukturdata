import 'dart:io';

class Pelanggan {
  String nama, alamat, nomor;
  int queueNumber;

  Pelanggan(this.nama, this.alamat, this.queueNumber, this.nomor);

  @override
  String toString() {
    return 'Pelanggan {Nama: $nama, Alamat: $alamat, Nomor: $nomor, Nomor Antrian: $queueNumber}';
  }
}

class Node {
  Pelanggan data;
  Node? next;

  Node(this.data);
}

class SingleLinkedList {
  Node? head;

  void add(Pelanggan data) {
    if (head == null) {
      head = Node(data);
    } else {
      Node current = head!;
      while (current.next != null) {
        current = current.next!;
      }
      current.next = Node(data);
    }
  }

  Pelanggan? removeFirst() {
    if (head == null) {
      return null;
    } else {
      Pelanggan data = head!.data;
      head = head!.next;
      return data;
    }
  }

  bool get isEmpty => head == null;

  void display() {
    if (head == null) {
      print('Antrian daftar isi pelanggan kosong');
    } else {
      Node? current = head;
      print('Isi daftar antrian pelanggan:');
      while (current != null) {
        print(current.data);
        current = current.next;
      }
    }
  }

  List<Pelanggan> toList() {
    List<Pelanggan> list = [];
    Node? current = head;
    while (current != null) {
      list.add(current.data);
      current = current.next;
    }
    return list;
  }

  bool batalkanPemasangan(String nama) {
    Node? current = head;
    Node? previous;

    while (current != null) {
      if (current.data.nama.toLowerCase() == nama.toLowerCase()) {
        if (previous == null) {
          head = current.next;
        } else {
          previous.next = current.next;
        }
        return true;
      }
      previous = current;
      current = current.next;
    }
    return false;
  }
}

class antrianPemasanganwifi {
  SingleLinkedList queue = SingleLinkedList();
  int lastQueueNumber = 0;
  String filePath = 'daftar_pelanggan.csv';

  antrianPemasanganwifi() {
    loadQueueFromFile();
  }

  void loadQueueFromFile() {
    try {
      File file = File(filePath);
      if (file.existsSync()) {
        List<String> lines = file.readAsLinesSync();
        for (String line in lines) {
          List<String> parts = line.split(',');
          if (parts.length == 4) {
            String nama = parts[0];
            String alamat = parts[1];
            String nomor = parts[2];
            int queueNumber = int.tryParse(parts[3]) ?? 0;
            queue.add(Pelanggan(nama, alamat, queueNumber, nomor));
            if (queueNumber > lastQueueNumber) {
              lastQueueNumber = queueNumber;
            }
          }
        }
      }
    } catch (e) {
      print('Terjadi kesalahan dalam memuat data: $e');
    }
  }

  void saveQueueToFile() {
    try {
      List<Pelanggan> list = queue.toList();
      File file = File(filePath);
      IOSink sink = file.openWrite();
      for (Pelanggan pelanggan in list) {
        sink.writeln(
            '${pelanggan.nama},${pelanggan.alamat},${pelanggan.nomor},${pelanggan.queueNumber}');
      }
      sink.close();
    } catch (e) {
      print('Terjadi kesalahan dalam menyimpan data: $e');
    }
  }

  void addToQueue(String name, String alamat, String nomor) {
    lastQueueNumber++;
    Pelanggan pelanggan = Pelanggan(name, alamat, lastQueueNumber, nomor);
    queue.add(pelanggan);
    print(
        '${pelanggan.nama} telah dimasukkan ke dalam antrian dengan nomor ${pelanggan.queueNumber}');
    saveQueueToFile();
  }

  void serveNextCustomer() {
    Pelanggan? pelanggan = queue.removeFirst();
    if (pelanggan == null) {
      print('Antrian daftar pelanggan kosong');
    } else {
      print(
          'Pemasangan WiFi untuk ${pelanggan.nama} dengan nomor antrian ${pelanggan.queueNumber} sedang dilakukan.');
      saveQueueToFile();
    }
  }

  void batalkanPemasangan(String nama) {
    if (queue.batalkanPemasangan(nama)) {
      print('Pelanggan dengan nama $nama telah dibatalkan.');
      saveQueueToFile();
    } else {
      print('Pelanggan dengan nama $nama tidak ditemukan.');
    }
  }

  void displayQueue() {
    queue.display();
  }

  Pelanggan? search(String dataPelanggan) {
    Node? current = queue.head;
    while (current != null) {
      if (current.data.nama.toLowerCase() == dataPelanggan.toLowerCase() ||
          current.data.alamat.toLowerCase() == dataPelanggan.toLowerCase()) {
        return current.data;
      }
      current = current.next;
    }
    return null;
  }
}
