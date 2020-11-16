import ContactsUI

extension CNContact {
    var fullName: String {
        var name = ""
        if !namePrefix.isEmpty { name += namePrefix }
        if !givenName.isEmpty { name += " \(givenName)" }
        if !middleName.isEmpty { name += " \(middleName)" }
        if !familyName.isEmpty { name += " \(familyName)" }
        if !nameSuffix.isEmpty { name += " \(nameSuffix)" }
        return name.trim()
    }

    var defaultEmail: String {
        emailAddresses
            .filter { $0.value.length != 0 }
            .first?.value as String? ?? ""
    }

    var defaultFullAddress: String {
        postalAddresses
            .filter { !$0.value.fullAddress.isEmpty }
            .first?.value.fullAddress ?? ""
    }

    var faxNumber: String {
        phoneNumbers.filter {
            [CNLabelPhoneNumberHomeFax,
             CNLabelPhoneNumberWorkFax,
             CNLabelPhoneNumberOtherFax].contains($0.label)
        }
        .filter { !$0.value.stringValue.isEmpty }
        .first?.value.stringValue ?? ""
    }

    var phoneNumber: String {
        // except fax and mobile
        phoneNumbers.filter {
            ![CNLabelPhoneNumberHomeFax,
             CNLabelPhoneNumberWorkFax,
             CNLabelPhoneNumberOtherFax,
             CNLabelPhoneNumberMobile].contains($0.label)
        }
        .filter { !$0.value.stringValue.isEmpty }
        .first?.value.stringValue ?? ""
    }

    var mobileNumber: String {
        phoneNumbers.filter {
            $0.label == CNLabelPhoneNumberMobile
        }
        .filter { !$0.value.stringValue.isEmpty }
        .first?.value.stringValue ?? ""
    }
}

extension CNPostalAddress {
    var fullAddress: String {
        CNPostalAddressFormatter.string(from: self, style: .mailingAddress)
    }
}
