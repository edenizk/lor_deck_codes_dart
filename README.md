# Runeterra Dart

This project is a dart library for decoding and encoding decks in Legend of Runeterra.
It is based on [RiotGames/LoRDeckCodes](https://github.com/RiotGames/LoRDeckCodes)

## Install

Installation is in [lor_deck_codes_dart](https://pub.dev/packages/lor_deck_codes_dart) in Installing section

## How to use

You can create deck like I showed down below.
This deck is [Budget Elites (New Players)](https://lor.mobalytics.gg/decks/bojrj0dp0i9p574edqug)
from [lor.mobalytics.gg](https://lor.mobalytics.gg).

you can also find an example in [example/example.dart](https://github.com/edenizk/lor_deck_codes_dart/blob/master/example/example.dart) file

### Decode

```dart
List<CardCodeAndCount> deck = LoRDeckEncoder.GetDeckFromCode(
      'CEAQQAIAAECAMFBCEQTTMAQCAEBASGQFAEAAGCYSDUXQCAQBAADQY');  
      /* 
        3:01DE001
        3:01DE004
        3:01DE006
        3:01DE020
        3:01DE034
        3:01DE036
        3:01DE039
        3:01DE054
        2:01IO009
        2:01IO026
        2:01DE003
        2:01DE011
        2:01DE018
        2:01DE029
        2:01DE047
        1:01DE007
        1:01DE012
      */
      deck[0].CardCode //01DE001
      deck[0].Count //3
```

### Encode

```dart
  String code = LoRDeckEncoder.GetCodeFromDeck(deck);
  //CEAQQAIAAECAMFBCEQTTMAQCAEBASGQFAEAAGCYSDUXQCAQBAADQY
```

### Adding a new deck class

I am no longer following Runeterra closly, in case if there will be an new deck class, please create a new issue for me so I can get an notification.  
Or if you are brave enough you can add a new deck class by your self. don't worry it is easier than you think ;)  
Navigate to the [lib/LoRDeckEncoder.dart](https://github.com/edenizk/lor_deck_codes_dart/blob/master/lib/LoRDeckEncoder.dart) file.  
There on line 10, 24, 37, and 19, you will see notes follow the basic notes create a merge request, and I will take a look as soon as I can :)  
  
## BONUS

Would be awsome if you could add a basic UnitTest by copying the latest test unit, and changing the card identifier 

``` (e.g. 01DE012 --> 01SH012) ```
You can find the unit test script in the test folder.  
For testing type

``` dart test test/UnitTest.dart ```

## Notes

This package is using [fixnum](https://pub.dev/packages/fixnum) package for creating a fixed-width 32-bit integer in dart
