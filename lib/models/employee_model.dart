class Employee {
  String id;
  String name;
  Address address;
  List<Contact> contacts;

  Employee({
    required this.id,
    required this.name,
    required this.address,
    required this.contacts,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['name'],
      address: Address.fromJson(json['address']),
      contacts: (json['contacts'] as List)
          .map((contact) => Contact.fromJson(contact))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address.toJson(),
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
  }
}

class Address {
  String line1;
  String city;
  String country;
  String zipCode;

  Address({
    required this.line1,
    required this.city,
    required this.country,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      line1: json['line1'],
      city: json['city'],
      country: json['country'],
      zipCode: json['zip_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line1': line1,
      'city': city,
      'country': country,
      'zip_code': zipCode,
    };
  }
}

class Contact {
  String contactMethod;
  String value;

  Contact({
    required this.contactMethod,
    required this.value,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      contactMethod: json['contact_method'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_method': contactMethod,
      'value': value,
    };
  }
}
