import 'dart:typed_data';

import 'package:lor_deck_codes_dart/Base32.dart';
import 'package:lor_deck_codes_dart/CardCodeAndCount.dart';
import 'package:lor_deck_codes_dart/VarintTranslator.dart';

class LoRDeckEncoder {
  static final int _card_code_length = 7;
  // static Map<String, int> _factionCodeToIntIdentifier = HashMap<String, int>();
  static Map<String, int> _factionCodeToIntIdentifier = <String, int>{
    'DE': 0,
    'FR': 1,
    'IO': 2,
    'NX': 3,
    'PZ': 4,
    'SI': 5,
  };

  //static Map<int, String> _intIdentifierToFactionCode = HashMap<int, String>();
  static Map<int, String> _intIdentifierToFactionCode = <int, String>{
    0: 'DE',
    1: 'FR',
    2: 'IO',
    3: 'NX',
    4: 'PZ',
    5: 'SI',
  };
  static final int _max_known_version = 1;

  //dart does't support static constructor,
  //until find something works like static constructor
  //we need to asign objects before constructor
  LoRDeckEncoder() {}

  static List<CardCodeAndCount> GetDeckFromCode(String code) {
    List<CardCodeAndCount> result = List<CardCodeAndCount>();

    Uint8List bytes;
    try {
      bytes = Base32.Decode(code);
    } catch (e) {
      throw ArgumentError('Invalid deck code ' + e);
    }

    List<int> byteList = bytes.toList();

    //grab format and version
    int format = bytes[0] >> 4;
    int version = bytes[0] & 0xF;
    byteList.removeAt(0);
    if (version > _max_known_version) {
      throw ArgumentError(
          "The provided code requires a higher version of this library; please update.");
    }

    for (int i = 3; i > 0; i--) {
      int numGroupOfs = VarintTranslator.PopVarint(byteList);

      for (int j = 0; j < numGroupOfs; j++) {
        int numOfsInThisGroup = VarintTranslator.PopVarint(byteList);
        int set = VarintTranslator.PopVarint(byteList);
        int faction = VarintTranslator.PopVarint(byteList);

        for (int k = 0; k < numOfsInThisGroup; k++) {
          int card = VarintTranslator.PopVarint(byteList);

          String setString = set.toString().padLeft(2, '0');
          String factionString = _intIdentifierToFactionCode[faction];
          String cardString = card.toString().padLeft(3, '0');

          CardCodeAndCount newEntry =
              CardCodeAndCount(setString + factionString + cardString, i);
          result.add(newEntry);
        }
      }
    }
    //the remainder of the deck code is comprised of entries for cards with counts >= 4
    //this will only happen in Limited and special game modes.
    //the encoding is simply [count] [cardcode]
    while (byteList.isNotEmpty) {
      int fourPlusCount = VarintTranslator.PopVarint(byteList);
      int fourPlusSet = VarintTranslator.PopVarint(byteList);
      int fourPlusFaction = VarintTranslator.PopVarint(byteList);
      int fourPlusNumber = VarintTranslator.PopVarint(byteList);

      String fourPlusSetString = fourPlusSet.toString().padLeft(2, '0');
      String fourPlusFactionString =
          _intIdentifierToFactionCode[fourPlusFaction];
      String fourPlusNumberString = fourPlusNumber.toString().padLeft(3, '0');

      CardCodeAndCount newEntry = CardCodeAndCount(
          fourPlusSetString + fourPlusFactionString + fourPlusNumberString,
          fourPlusCount);
      result.add(newEntry);
    }

    return result;
  }

  static String GetCodeFromDeck(List<CardCodeAndCount> deck) {
    String result = Base32.Encode(_getDeckCodeBytes(deck));
    return result;
  }

  static List<Uint8List> _getDeckCodeBytes(List<CardCodeAndCount> deck) {
    List<Uint8List> result = <Uint8List>[];

    if (!ValidCardCodesAndCounts(deck)) {
      throw ArgumentError('The provided deck contains invalid card codes.');
    }

    Uint8List formatAndVersion = Uint8List(1); //i.e. 00010001
    formatAndVersion[0] = 17;
    result.add(formatAndVersion);

    List<CardCodeAndCount> of3 = <CardCodeAndCount>[];
    List<CardCodeAndCount> of2 = <CardCodeAndCount>[];
    List<CardCodeAndCount> of1 = <CardCodeAndCount>[];
    List<CardCodeAndCount> ofN = <CardCodeAndCount>[];

    for (CardCodeAndCount ccc in deck) {
      if (ccc.Count == 3)
        of3.add(ccc);
      else if (ccc.Count == 2)
        of2.add(ccc);
      else if (ccc.Count == 1)
        of1.add(ccc);
      else if (ccc.Count < 1) {
        throw ArgumentError("Invalid count of " +
            ccc.Count.toString() +
            " for card " +
            ccc.CardCode);
      } else
        ofN.add(ccc);
    }
    //build the lists of set and faction combinations within the groups of similar card counts
    List<List<CardCodeAndCount>> groupedOf3s = _getGroupedOfs(of3.toList());
    List<List<CardCodeAndCount>> groupedOf2s = _getGroupedOfs(of2.toList());
    List<List<CardCodeAndCount>> groupedOf1s = _getGroupedOfs(of1.toList());

    //to ensure that the same decklist in any order produces the same code, do some sorting
    groupedOf3s = _sortGroupOf(groupedOf3s);
    groupedOf2s = _sortGroupOf(groupedOf2s);
    groupedOf1s = _sortGroupOf(groupedOf1s);

    //Nofs (since rare) are simply sorted by the card code - there's no optimiziation based upon the card count
    //ofN = ofN.sort((c) => c.CardCode).ToList();
    ofN.sort((a, b) => a.CardCode.compareTo(b.CardCode));

    //Encode
    _encodeGroupOf(result, groupedOf3s);
    _encodeGroupOf(result, groupedOf2s);
    _encodeGroupOf(result, groupedOf1s);

    //Cards with 4+ counts are handled differently: simply [count] [card code] for each
    _encodeNOfs(result, ofN);

    return result;
  }

  static void _encodeNOfs(List<Uint8List> bytes, List<CardCodeAndCount> nOfs) {
    for (CardCodeAndCount ccc in nOfs) {
      bytes.add(VarintTranslator.GetVarint(ccc.Count));
      //TODO _parseCardCode method needs to be created.
      //This part can be written in better way in dart. Like in:
      //_parseCardCode(ccc.CardCode, out int setNumber, out string factionCode, out int cardNumber);
      //But for now I am skipping it.
      int setNumber = int.parse(ccc.CardCode.substring(0, 2));
      String factionCode = ccc.CardCode.substring(2, 4);
      int cardNumber = int.parse(ccc.CardCode.substring(4));

      int factionNumber = _factionCodeToIntIdentifier[factionCode];

      bytes.add(VarintTranslator.GetVarint(setNumber));
      bytes.add(VarintTranslator.GetVarint(factionNumber));
      bytes.add(VarintTranslator.GetVarint(cardNumber));
    }
  }

  //The sorting convention of this encoding scheme is
  //First by the number of set/faction combinations in each top-level list
  //Second by the alphanumeric order of the card codes within those lists.
  static List<List<CardCodeAndCount>> _sortGroupOf(
      List<List<CardCodeAndCount>> groupOf) {
    groupOf.sort((a, b) => a.length.compareTo(b.length));
    for (int i = 0; i < groupOf.length; i++) {
      groupOf[i].sort((a, b) => a.CardCode.compareTo(b.CardCode));
    }
    return groupOf;
  }

  static List<List<CardCodeAndCount>> _getGroupedOfs(
      List<CardCodeAndCount> list) {
    List<List<CardCodeAndCount>> result = List<List<CardCodeAndCount>>();
    while (list.length > 0) {
      List<CardCodeAndCount> currentSet = List<CardCodeAndCount>();

      //get info from first
      String firstCardCode = list[0].CardCode;

      //TODO _parseCardCode method needs to be created.
      //_parseCardCode(firstCardCode, out int setNumber, out string factionCode, out int cardNumber);
      int setNumber = int.parse(firstCardCode.substring(0, 2));
      String factionCode = firstCardCode.substring(2, 4);

      //now add that to our new list, remove from old
      currentSet.add(list[0]);
      list.removeAt(0);

      //sweep through rest of list and grab entries that should live with our first one.
      //matching means same set and faction - we are already assured the count matches from previous grouping.
      for (int i = list.length - 1; i >= 0; i--) {
        String currentCardCode = list[i].CardCode;
        int currentSetNumber = int.parse(currentCardCode.substring(0, 2));
        String currentFactionCode = currentCardCode.substring(2, 4);

        if (currentSetNumber == setNumber &&
            currentFactionCode == factionCode) {
          currentSet.add(list[i]);
          list.removeAt(i);
        }
      }
      result.add(currentSet);
    }
    return result;
  }

  static void _encodeGroupOf(
      List<Uint8List> bytes, List<List<CardCodeAndCount>> groupOf) {
    bytes.add(VarintTranslator.GetVarint(groupOf.length));
    for (List<CardCodeAndCount> currentList in groupOf) {
      //how many cards in current group?
      bytes.add(VarintTranslator.GetVarint(currentList.length));

      //what is this group, as identified by a set and faction pair
      String currentCardCode = currentList[0].CardCode;

      //TODO _parseCardCode method needs to be created.
      //ParseCardCode(currentCardCode, out int currentSetNumber, out string currentFactionCode, out int _);
      int currentSetNumber = int.parse(currentCardCode.substring(0, 2));
      String currentFactionCode = currentCardCode.substring(2, 4);

      int currentFactionNumber =
          _factionCodeToIntIdentifier[currentFactionCode];
      bytes.add(VarintTranslator.GetVarint(currentSetNumber));
      bytes.add(VarintTranslator.GetVarint(currentFactionNumber));

      //what are the cards, as identified by the third section of card code only now, within this group?
      for (CardCodeAndCount cd in currentList) {
        String code = cd.CardCode;
        int sequenceNumber = int.parse(code.substring(4));
        bytes.add(VarintTranslator.GetVarint(sequenceNumber));
      }
    }
  }

  static bool ValidCardCodesAndCounts(List<CardCodeAndCount> deck) {
    for (CardCodeAndCount ccc in deck) {
      if (ccc.CardCode.length != _card_code_length) return false;

      //int parsed;
      if (int.tryParse(ccc.CardCode.substring(0, 2)) == null) return false;

      String faction = ccc.CardCode.substring(2, 4);
      if (!_factionCodeToIntIdentifier.containsKey(faction)) return false;

      if (int.tryParse(ccc.CardCode.substring(0, 2)) == null) return false;

      if (ccc.Count < 1) return false;
    }
    return true;
  }
}
