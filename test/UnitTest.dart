import 'package:test/test.dart';
import 'package:lor_deck_codes_dart/CardCodeAndCount.dart';
import 'package:lor_deck_codes_dart/LoRDeckEncoder.dart';

void main() {
  bool VerifyRehydration(
      List<CardCodeAndCount> d, List<CardCodeAndCount> rehydratedList) {
    if (d.length != rehydratedList.length) return false;

    for (CardCodeAndCount cd in rehydratedList) {
      bool found = false;
      for (CardCodeAndCount cc in d) {
        if (cc.CardCode == cd.CardCode && cc.Count == cd.Count) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }
    return true;
  }

  test("SmallDeck", () {
    List<CardCodeAndCount> deck = List<CardCodeAndCount>();
    deck.add(CardCodeAndCount('01DE002', 1));

    String code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);
    expect(true, VerifyRehydration(deck, decoded));
  });
  test("LargeDeck", () {
    List<CardCodeAndCount> deck = List<CardCodeAndCount>();
    deck.add(new CardCodeAndCount("01DE002", 3));
    deck.add(new CardCodeAndCount("01DE002", 3));
    deck.add(new CardCodeAndCount("01DE003", 3));
    deck.add(new CardCodeAndCount("01DE004", 3));
    deck.add(new CardCodeAndCount("01DE005", 3));
    deck.add(new CardCodeAndCount("01DE006", 3));
    deck.add(new CardCodeAndCount("01DE007", 3));
    deck.add(new CardCodeAndCount("01DE008", 3));
    deck.add(new CardCodeAndCount("01DE009", 3));
    deck.add(new CardCodeAndCount("01DE010", 3));
    deck.add(new CardCodeAndCount("01DE011", 3));
    deck.add(new CardCodeAndCount("01IO012", 3));
    deck.add(new CardCodeAndCount("01DE013", 3));
    deck.add(new CardCodeAndCount("01DE014", 3));
    deck.add(new CardCodeAndCount("01DE015", 3));
    deck.add(new CardCodeAndCount("01DE016", 3));
    deck.add(new CardCodeAndCount("01DE017", 3));
    deck.add(new CardCodeAndCount("01DE018", 3));
    deck.add(new CardCodeAndCount("01DE019", 3));
    deck.add(new CardCodeAndCount("01DE020", 3));
    deck.add(new CardCodeAndCount("01DE021", 3));

    var code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);

    expect(true, VerifyRehydration(deck, decoded));
  });
  test("DeckWithCountsMoreThan3Small", () {
    List<CardCodeAndCount> deck = new List<CardCodeAndCount>();
    deck.add(new CardCodeAndCount('01DE002', 4));

    String code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);
    expect(true, VerifyRehydration(deck, decoded));
  });
  test("DeckWithCountsMoreThan3Large", () {
    List<CardCodeAndCount> deck = List<CardCodeAndCount>();
    deck.add(new CardCodeAndCount("01DE002", 3));
    deck.add(new CardCodeAndCount("01DE002", 3));
    deck.add(new CardCodeAndCount("01DE003", 3));
    deck.add(new CardCodeAndCount("01DE004", 3));
    deck.add(new CardCodeAndCount("01DE005", 3));
    deck.add(new CardCodeAndCount("01DE006", 4));
    deck.add(new CardCodeAndCount("01DE007", 5));
    deck.add(new CardCodeAndCount("01DE008", 6));
    deck.add(new CardCodeAndCount("01DE009", 7));
    deck.add(new CardCodeAndCount("01DE010", 8));
    deck.add(new CardCodeAndCount("01DE011", 9));
    deck.add(new CardCodeAndCount("01DE012", 3));
    deck.add(new CardCodeAndCount("01DE013", 3));
    deck.add(new CardCodeAndCount("01DE014", 3));
    deck.add(new CardCodeAndCount("01DE015", 3));
    deck.add(new CardCodeAndCount("01DE016", 3));
    deck.add(new CardCodeAndCount("01DE017", 3));
    deck.add(new CardCodeAndCount("01DE018", 3));
    deck.add(new CardCodeAndCount("01DE019", 3));
    deck.add(new CardCodeAndCount("01DE020", 3));
    deck.add(new CardCodeAndCount("01DE021", 3));

    var code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);
    expect(true, VerifyRehydration(deck, decoded));
  });
  test("SingleCard40Times", () {
    List<CardCodeAndCount> deck = new List<CardCodeAndCount>();
    deck.add(new CardCodeAndCount('01DE002', 40));

    String code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);
    expect(true, VerifyRehydration(deck, decoded));
  });
  test("WorstCaseLength", () {
    List<CardCodeAndCount> deck = List<CardCodeAndCount>();
    deck.add(new CardCodeAndCount("01DE002", 4));
    deck.add(new CardCodeAndCount("01DE002", 4));
    deck.add(new CardCodeAndCount("01DE003", 4));
    deck.add(new CardCodeAndCount("01DE004", 4));
    deck.add(new CardCodeAndCount("01DE005", 4));
    deck.add(new CardCodeAndCount("01DE006", 4));
    deck.add(new CardCodeAndCount("01DE007", 5));
    deck.add(new CardCodeAndCount("01DE008", 6));
    deck.add(new CardCodeAndCount("01DE009", 7));
    deck.add(new CardCodeAndCount("01DE010", 8));
    deck.add(new CardCodeAndCount("01DE011", 9));
    deck.add(new CardCodeAndCount("01DE012", 4));
    deck.add(new CardCodeAndCount("01DE013", 4));
    deck.add(new CardCodeAndCount("01DE014", 4));
    deck.add(new CardCodeAndCount("01DE015", 4));
    deck.add(new CardCodeAndCount("01DE016", 4));
    deck.add(new CardCodeAndCount("01DE017", 4));
    deck.add(new CardCodeAndCount("01DE018", 4));
    deck.add(new CardCodeAndCount("01DE019", 4));
    deck.add(new CardCodeAndCount("01DE020", 4));
    deck.add(new CardCodeAndCount("01DE021", 4));

    var code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);
    expect(true, VerifyRehydration(deck, decoded));
  });
  test("OrderShouldNotMatter1", () {
    List<CardCodeAndCount> deck1 = new List<CardCodeAndCount>();
    deck1.add(CardCodeAndCount("01DE002", 1));
    deck1.add(CardCodeAndCount("01DE003", 2));
    deck1.add(CardCodeAndCount("02DE003", 3));

    List<CardCodeAndCount> deck2 = new List<CardCodeAndCount>();
    deck2.add(new CardCodeAndCount("01DE003", 2));
    deck2.add(new CardCodeAndCount("02DE003", 3));
    deck2.add(new CardCodeAndCount("01DE002", 1));

    String code1 = LoRDeckEncoder.GetCodeFromDeck(deck1);
    String code2 = LoRDeckEncoder.GetCodeFromDeck(deck2);

    expect(code1, code2);

    List<CardCodeAndCount> deck3 = new List<CardCodeAndCount>();
    deck3.add(new CardCodeAndCount("01DE002", 4));
    deck3.add(new CardCodeAndCount("01DE003", 2));
    deck3.add(new CardCodeAndCount("02DE003", 3));

    List<CardCodeAndCount> deck4 = new List<CardCodeAndCount>();
    deck4.add(new CardCodeAndCount("01DE003", 2));
    deck4.add(new CardCodeAndCount("01DE003", 3));
    deck4.add(new CardCodeAndCount("01DE002", 4));

    String code3 = LoRDeckEncoder.GetCodeFromDeck(deck1);
    String code4 = LoRDeckEncoder.GetCodeFromDeck(deck2);

    expect(code3, code4);
  });
  test("OrderShouldNotMatter2", () {
    List<CardCodeAndCount> deck1 = new List<CardCodeAndCount>();
    deck1.add(CardCodeAndCount("01DE002", 4));
    deck1.add(CardCodeAndCount("01DE003", 2));
    deck1.add(CardCodeAndCount("02DE003", 3));
    deck1.add(CardCodeAndCount("01DE004", 5));

    List<CardCodeAndCount> deck2 = new List<CardCodeAndCount>();
    deck2.add(new CardCodeAndCount("01DE004", 5));
    deck2.add(new CardCodeAndCount("01DE003", 2));
    deck2.add(new CardCodeAndCount("02DE003", 3));
    deck2.add(new CardCodeAndCount("01DE002", 4));

    String code1 = LoRDeckEncoder.GetCodeFromDeck(deck1);
    String code2 = LoRDeckEncoder.GetCodeFromDeck(deck2);

    expect(code1, code2);
  });
  test("BilgewaterSet", () {
    List<CardCodeAndCount> deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01DE002", 4));
    deck.add(CardCodeAndCount("02BW003", 2));
    deck.add(CardCodeAndCount("02BW010", 3));
    deck.add(CardCodeAndCount("01DE004", 5));
    
    var code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);

    expect(true, VerifyRehydration(deck, decoded));
  });
  test("BadCardCodes", () {
    List<CardCodeAndCount> deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01XX02", 1));
    try {
      String code = LoRDeckEncoder.GetCodeFromDeck(deck);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }

    deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01XX002", 1));

    try {
      String code = LoRDeckEncoder.GetCodeFromDeck(deck);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }

    deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01DE002", 0));

    try {
      String code = LoRDeckEncoder.GetCodeFromDeck(deck);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }
  });
  test("BadCount", () {
    List<CardCodeAndCount> deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01DE002", 0));

    try {
      String code = LoRDeckEncoder.GetCodeFromDeck(deck);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }

    deck = new List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01DE002", -1));
    try {
      String code = LoRDeckEncoder.GetCodeFromDeck(deck);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }
  });
  test("GarbageDecoding", () {
    String badEncodingNotBase32 = "I'm no card code!";
    String badEncoding32 = "ABCDEFG";
    String badEncodingEmpty = "";

    try {
      List<CardCodeAndCount> deck =
          LoRDeckEncoder.GetDeckFromCode(badEncodingNotBase32);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }

    try {
      List<CardCodeAndCount> deck =
          LoRDeckEncoder.GetDeckFromCode(badEncoding32);
      expect("fail", "");
    } catch (ArgumentException) {} catch (e) {
      expect("fail", "");
    }

    try {
      List<CardCodeAndCount> deck =
          LoRDeckEncoder.GetDeckFromCode(badEncodingEmpty);
      expect("fail", "");
    } catch (e) {}
  });
  test("Targon", () {
    List<CardCodeAndCount> deck = List<CardCodeAndCount>();
    deck.add(CardCodeAndCount("01DE002", 4));
    deck.add(CardCodeAndCount("03MT003", 2));
    deck.add(CardCodeAndCount("03MT010", 3));
    deck.add(CardCodeAndCount("02BW004", 5));
    deck.add(CardCodeAndCount("01DE005", 3));
    deck.add(CardCodeAndCount("01DE006", 3));
    deck.add(CardCodeAndCount("01DE007", 3));
    deck.add(CardCodeAndCount("01DE008", 3));
    deck.add(CardCodeAndCount("01DE009", 3));
    deck.add(CardCodeAndCount("01DE010", 3));
    deck.add(CardCodeAndCount("01DE011", 3));
    deck.add(CardCodeAndCount("01IO012", 3));
    deck.add(CardCodeAndCount("01DE013", 3));
    deck.add(CardCodeAndCount("01MT014", 3));
    deck.add(CardCodeAndCount("01DE015", 3));
    deck.add(CardCodeAndCount("01DE016", 3));
    deck.add(CardCodeAndCount("01MT017", 3));
    deck.add(CardCodeAndCount("01DE018", 3));
    deck.add(CardCodeAndCount("01DE019", 3));
    deck.add(CardCodeAndCount("01DE020", 3));
    deck.add(CardCodeAndCount("01DE021", 3));

    var code = LoRDeckEncoder.GetCodeFromDeck(deck);
    List<CardCodeAndCount> decoded = LoRDeckEncoder.GetDeckFromCode(code);

    expect(true, VerifyRehydration(deck, decoded));
  });
}