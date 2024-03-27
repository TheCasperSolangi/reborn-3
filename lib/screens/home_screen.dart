import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bet_app/New_Model/new_model.dart';
import 'package:bet_app/Services/navigation_service.dart';
import 'package:bet_app/Utils/color_constants.dart';
import 'package:bet_app/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? source;
  String? sportName;
  String? _success;
  String? eventTitle;

  bool _isExpandedEventsList = false;
  List<String> _events = []; // List to store fetched events


  bool _isExpanded = false;
  List<dynamic> _cricketEvents = [];
  List<dynamic> _soccerEvents = [];
  List<dynamic> _tennisEvents = [];
  List<dynamic> _horseEvents = [];
  List<dynamic> _greyhoundEvents = [];
  List<dynamic> _greyEvents = [];

  Future<void> fetchCricketEvents() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Cricket';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          // Loop through each 'response' object based on the source
          for (var responseItem in jsonData['response']) {
            String source = responseItem['source'];

            if (source == 'OddsAPI') {
              // Handle OddsAPI structure (consider error handling)
              List<dynamic> activeEvents = responseItem['active events'];
              setState(() {
                _cricketEvents = activeEvents;
              });
              break; // Assuming only OddsAPI data is needed
            } else if (source == 'BetsAPI') {
              // Handle BetsAPI structure (similar to OddsAPI)
              // ...
            } else {
              // Handle unexpected source or missing data
              print('Unknown source: $source');
            }
          }
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }

// API Calling for Sub Events...


bool _isSoccerExpanded = false;


  Future<void> fetchSoccerEvents() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Soccer';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          // Loop through each 'response' object based on the source
          for (var responseItem in jsonData['response']) {
            String source = responseItem['source'];

            if (source == 'OddsAPI') {
              // Handle OddsAPI structure (consider error handling)
              List<dynamic> activeEvents = responseItem['active events'];
              setState(() {
                _soccerEvents = activeEvents;
              });
              break; // Assuming only OddsAPI data is needed
            } else if (source == 'BetsAPI') {
              // Handle BetsAPI structure (similar to OddsAPI)
              // ...
            } else {
              // Handle unexpected source or missing data
              print('Unknown source: $source');
            }
          }
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }


// API Calling for Sub Events Soccer...



  List<dynamic> _subEvents = []; // Store parsed sub-events

  Future<void> fetchCricketEventsSub() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Cricket';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          List<dynamic> eventsResponse = jsonData['response'];

          // Loop through each 'active events' object
          for (var activeEvents in eventsResponse) {
            List<dynamic> subEvents = activeEvents['active events'];
            _subEvents.addAll(subEvents); // Add all sub-events to the list
          }

          // Rebuild the widget with the fetched data
          setState(() {});
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }

// API Calling for Sub Events Ends Here

// API Calling now for soccer

  Future<void> fetchCricketEventsSoccer() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Soccer';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          List<dynamic> eventsResponse = jsonData['response'];

          // Loop through each 'active events' object
          for (var activeEvents in eventsResponse) {
            String source = activeEvents['source'];
            String sportName = activeEvents['sport name'];
            print('Source: $source');
            print('Sport Name: $sportName');

            List<dynamic> events = activeEvents['active events'];
            for (var event in events) {
              String eventTitle = event['event title'];
              String description = event['description'];
              print('Event Title: $eventTitle');
              print('Description: $description');

              List<dynamic> subEvents = event['active events'];
              for (var subEvent in subEvents) {
                String homeTeam = subEvent['home_team'];
                String awayTeam = subEvent['away_team'];
                String commenceTime = subEvent['commence_time'];
                String id = subEvent['id'];
                String sportKey = subEvent['sport_key'];

                print('Home Team: $homeTeam');
                print('Away Team: $awayTeam');
                print('Commence Time: $commenceTime');
                print('ID: $id');
                print('Sport Key: $sportKey');
                print('------------------------');
              }
            }
          }
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }

// API Calling for soccer ends

// API Calling for Tennis

  Future<void> fetchCricketEventsTennis() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Tennis';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          List<dynamic> eventsResponse = jsonData['response'];

          // Loop through each 'active events' object
          for (var activeEvents in eventsResponse) {
            String source = activeEvents['source'];
            String sportName = activeEvents['sport name'];
            print('Source: $source');
            print('Sport Name: $sportName');

            List<dynamic> events = activeEvents['active events'];
            for (var event in events) {
              String eventTitle = event['event title'];
              String description = event['description'];
              print('Event Title: $eventTitle');
              print('Description: $description');

              List<dynamic> subEvents = event['active events'];
              for (var subEvent in subEvents) {
                String homeTeam = subEvent['home_team'];
                String awayTeam = subEvent['away_team'];
                String commenceTime = subEvent['commence_time'];
                String id = subEvent['id'];
                String sportKey = subEvent['sport_key'];

                print('Home Team: $homeTeam');
                print('Away Team: $awayTeam');
                print('Commence Time: $commenceTime');
                print('ID: $id');
                print('Sport Key: $sportKey');
                print('------------------------');
              }
            }
          }
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }

// API Calling for Tennis Ends Here

// API Calling for Horse

  Future<void> fetchCricketEventsHorse() async {
    // Define the endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Horse Racing';

    try {
      // Make the GET request
      http.Response response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the JSON response
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        // Check if 'success' is true
        if (jsonData['success'] == true) {
          List<dynamic> eventsResponse = jsonData['response'];

          // Loop through each 'active events' object
          for (var activeEvents in eventsResponse) {
            String source = activeEvents['source'];
            String sportName = activeEvents['sport name'];
            print('Source: $source');
            print('Sport Name: $sportName');

            List<dynamic> events = activeEvents['active events'];
            for (var event in events) {
              String eventTitle = event['event title'];
              String description = event['description'];
              print('Event Title: $eventTitle');
              print('Description: $description');

              List<dynamic> subEvents = event['active events'];
              for (var subEvent in subEvents) {
                String homeTeam = subEvent['home_team'];
                String awayTeam = subEvent['away_team'];
                String commenceTime = subEvent['commence_time'];
                String id = subEvent['id'];
                String sportKey = subEvent['sport_key'];

                print('Home Team: $homeTeam');
                print('Away Team: $awayTeam');
                print('Commence Time: $commenceTime');
                print('ID: $id');
                print('Sport Key: $sportKey');
                print('------------------------');
              }
            }
          }
        } else {
          // If 'success' is false
          print('Failed to load cricket events. Success: false');
        }
      } else {
        // If request was not successful, print the error
        print(
            'Failed to load cricket events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur
      print('Error fetching cricket events: $e');
    }
  }

// API Calling for Horse Ends Here

// Fetching the tennis sub events 

Future<void> fetchTennisSubEvents() async {
  // Define the endpoint URL (replace with actual URL if different)
  String url = 'https://salman138.pythonanywhere.com/events/Tennis';

  try {
    // Make the GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // If successful, parse the JSON response
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Check if 'success' is true
      if (jsonData['success'] == true) {
        // Loop through each 'response' object
        for (var responseItem in jsonData['response']) {
          String source = responseItem['source'];

          if (source == 'OddsAPI') {
            // Handle OddsAPI structure
            List<dynamic> activeEvents = responseItem['active events'];
            setState(() {
              _tennisEvents.addAll(activeEvents); // Add all tennis events
            });
            break; // Assuming only OddsAPI data is needed for tennis
          } else {
            // Ignore other sources for tennis
            print('Ignoring source for Tennis: $source');
          }
        }
      } else {
        // If 'success' is false
        print('Failed to load tennis events. Success: false');
      }
    } else {
      // If request was not successful, print the error
      print(
          'Failed to load tennis events. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any exceptions that occur
    print('Error fetching tennis events: $e');
  }
}

// Updated Greyhounds

  Future<void> fetchGreyhoundsEvents() async {
    HttpClient httpClient = HttpClient();
    const String url = 'https://salman138.pythonanywhere.com/events/Greyhounds';

    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        String responseBody = await response.transform(utf8.decoder).join();
        Map<String, dynamic> data = json.decode(responseBody);

        List<dynamic> eventsResponse = data['response'];
        for (var eventsData in eventsResponse) {
          String source = eventsData['source'];
          String sportName = eventsData['sport name'];
          dynamic success = eventsData['success']; // Store as dynamic

          print('Source: $source');
          print('Sport Name: $sportName');
          print('Success: $success');

          if (eventsData.containsKey('active events')) {
            List<dynamic> activeEvents = eventsData['active events'];
            for (var event in activeEvents) {
              print('\nEvent Title: ${event['event title']}');
              print('Commence Time: ${event['commence_time']}');
              print('Event Key: ${event['event_key']}');
              if (event['home'] != null) {
                print('Home: ${event['home']['name']}');
              } else {
                print('Home: N/A');
              }
              if (event['away'] != null) {
                print('Away: ${event['away']['name']}');
              } else {
                print('Away: N/A');
              }
            }
          }
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      httpClient.close();
    }
  }

// Updated Greyhounds
  bool _isExpandedCricket = false;
  bool _isExpandedHorse = false;

// Horse updated

  Future<void> fetchHorseRacingEvents() async {
    
    HttpClient httpClient = HttpClient();
    const String url =
        'https://salman138.pythonanywhere.com/events/Horse Racing';

    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        String responseBody = await response.transform(utf8.decoder).join();
        Map<String, dynamic> data = json.decode(responseBody);

        List<dynamic> eventsResponse = data['response'];
        for (var eventsData in eventsResponse) {
          String source = eventsData['source'];
          String sportName = eventsData['sport name'];
          dynamic success = eventsData['success']; // Store as dynamic

          print('Source: $source');
          print('Sport Name: $sportName');
          print('Success: $success');

          if (eventsData.containsKey('active events')) {
            List<dynamic> activeEvents = eventsData['active events'];
            for (var event in activeEvents) {
              print('\nEvent Title: ${event['event title']}');
              print('Commence Time: ${event['commence_time']}');
              print('Event Key: ${event['event_key']}');
              if (event['home'] != null) {
                print('Home: ${event['home']['name']}');
              } else {
                print('Home: N/A');
              }
              if (event['away'] != null) {
                print('Away: ${event['away']['name']}');
              } else {
                print('Away: N/A');
              }
            }
          }
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      httpClient.close();
    }
  }

// HOrse updated Ends
  bool _isExpandedSoccer = false;
// API Calling For Greyhounds
  Future<void> fetchTennisEvents() async {
    HttpClient httpClient = HttpClient();
    const String url = 'https://salman138.pythonanywhere.com/events/Tennis';
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        String responseBody = await response.transform(utf8.decoder).join();
        Map<String, dynamic> data = json.decode(responseBody);

        List<dynamic> eventsResponse = data['response'];
        for (var eventsData in eventsResponse) {
          String source = eventsData['source'];
          String sportName = eventsData['sport name'];
          dynamic success = eventsData['success']; // Store as dynamic

          print('Source: $source');
          print('Sport Name: $sportName');
          print('Success: $success');

          if (eventsData.containsKey('active events')) {
            List<dynamic> activeEvents = eventsData['active events'];
            for (var event in activeEvents) {
              print('\nEvent Title: ${event['event title']}');
              print('Commence Time: ${event['commence_time']}');
              print('Event Key: ${event['event_key']}');
              print('Home: ${event['home']['name']}');
              print('Away: ${event['away']['name']}');
            }
          }
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      httpClient.close();
    }
  }


 Future<void> _fetchHorseRacingEvents() async {
  try {
    // Replace with the actual endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Horse Racing';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('Horse Racing Response: $jsonData');

      if (jsonData['success'] == true) {
        List<dynamic> horseRacingEvents = [];

        for (var responseItem in jsonData['response']) {
          String source = responseItem['source'];

          if (source == 'OddsAPI' || source == 'BetsAPI') {
            // Handle both OddsAPI and BetsAPI structures
            List<dynamic> activeEvents = responseItem['active events'];
            horseRacingEvents.addAll(activeEvents);
          } else {
            // Handle unexpected source or missing data
            print('Unknown source for Horse Racing: $source');
          }
        }

        setState(() {
          _horseEvents = horseRacingEvents;
        });
      } else {
        print('Failed to load horse racing events. Success: false');
      }
    } else {
      print(
          'Failed to load horse racing events. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching horse racing events: $e');
  }
}


// Greyhound API Calling 


// 


 Future<void> _fetchGreyhoundsEvents() async {
  try {
    // Replace with the actual endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Greyhounds';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('Horse Racing Response: $jsonData');

      if (jsonData['success'] == true) {
        List<dynamic> greyHoundEvents = [];

        for (var responseItem in jsonData['response']) {
          String source = responseItem['source'];

          if (source == 'OddsAPI' || source == 'BetsAPI') {
            // Handle both OddsAPI and BetsAPI structures
            List<dynamic> activeEvents = responseItem['active events'];
            greyHoundEvents.addAll(activeEvents);
          } else {
            // Handle unexpected source or missing data
            print('Unknown source for Horse Racing: $source');
          }
        }

        setState(() {
          _greyEvents = greyHoundEvents;
        });
      } else {
        print('Failed to load horse racing events. Success: false');
      }
    } else {
      print(
          'Failed to load horse racing events. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching horse racing events: $e');
  }
}

// Greyhound API Calling Ends Here 

// API Calling TEnnis Events 
Future<void> _fetchTennisEvents() async {
  try {
    // Replace with the actual endpoint URL
    String url = 'https://salman138.pythonanywhere.com/events/Tennis';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      print('Tennis Response: $jsonData');

      if (jsonData['success'] == true) {
        List<dynamic> tennisEvents = [];

        // Loop through response items, using only BetsAPI
        for (var responseItem in jsonData['response']) {
          if (responseItem['source'] == 'BetsAPI') {
            // Extract and process active events from BetsAPI
            List<dynamic> activeEvents = responseItem['active events'];
            tennisEvents.addAll(activeEvents);
            break; // Exit loop after processing BetsAPI data
          } else {
            // Handle unexpected source or missing data (optional)
            print('Unexpected source or missing data for Tennis: ${responseItem['source']}');
          }
        }

        // Update state with extracted events
        setState(() {
          _tennisEvents = tennisEvents;
        });
      } else {
        print('Failed to load tennis events. Success: false');
      }
    } else {
      print('Failed to load tennis events. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching tennis events: $e');
  }
}

// API Calling For Greyhounds Ends Here

bool isSoccerNativeExpanded = false;
bool isCricketNativeExapnded = false;
bool isGreyHoundExpanded = false;
bool isHorseRacingExpanded = false;
bool isTennisExpanded = false;
bool isSoonCricketExpended = false;
bool isSoonSoccerExpended = false;
bool isSoonTennisExpended = false;
bool isTennisInPlayExpanded = false;


  List listNavigate = [
    "/exchange",
    "/fancy",
    '/cricket+exchange',
    '/administration'
  ];
  List listTitle = [
    "Cricket + Fancy",
    "Horse / Dog Racing",
    "Live TV ",
    "Administration"
  ];
  List listImage = [
    "assets/cricket.png",
    "assets/horse.jpg",
    "assets/live.jpg",
    "assets/admin.jpeg"
  ];
  List listsubTitle = [
    "Bet Online in Multiple Sports",
    "Bet Online in Fancy with Fancy Exchange",
    "Cricket/Fnacy on Same Screen",
    "Report and  Administration"
  ];
  late NavigationService _navigate;

  final User? user = FirebaseAuth.instance.currentUser;

  Future<String?> getroll() async {
    String uid = user!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String role = userDoc.get('role');
    return role;
  }

  late EventsController eventsController = Get.put(EventsController());

  @override
  void initState() {
    eventsController.fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _navigate = NavigationService();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
          title: Text(
            "Info Reborn New",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/download.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "My Market",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to Profile screen
                  fetchCricketEvents();
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle, color: Colors.black),
                    SizedBox(width: 10), // Spacing
                    Text(
                      "Inplay Events",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                onTap: () {
                  // Don't navigate to a separate screen
                  // Instead, expand/collapse the nested list
                  _isExpanded = !_isExpanded; // Toggle expansion state

                  // Rebuild the widget to reflect the change
                  setState(() {});
                },

                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust padding if needed
                subtitle: _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          // Nested list when expanded

                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Icon(Ionicons.caret_forward_circle,
                                      color: Colors.black),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Cricket",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          onTap: () async {
        await fetchCricketEvents();
        setState(() {
          _isExpandedCricket = !_isExpandedCricket;
        });
      },
      trailing: _isExpandedCricket && _cricketEvents.isNotEmpty
          ? null
          : null,
      subtitle: _isExpandedCricket
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cricketEvents.length,
                itemBuilder: (context, index) {
                  String eventTitle = _cricketEvents[index]['event title'];
                  // Access other event details here
                  // ...
                  return ListTile(
                    title: Row(
                      children: [
                          IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                        Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),),
                      ],
                    ),
                    // Add widgets for other details
                  );
                },
              ),
          )
          : null,
                            ),
                            ListTile(
                                title: Row(
                                  children: [
                                    Icon(Ionicons.caret_forward_circle,
                                        color: Colors.black),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Soccer",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                    onTap: () async {
        await fetchSoccerEvents();
        setState(() {
          _isSoccerExpanded = !_isSoccerExpanded;
        });
      },
      trailing: _isSoccerExpanded && _soccerEvents.isNotEmpty
          ? null
          : null,
      subtitle: _isSoccerExpanded
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _soccerEvents.length,
                itemBuilder: (context, index) {
                  String eventTitle = _soccerEvents[index]['event title'];
                  // Access other event details here
                  // ...
                  return ListTile(
                    title: Row(
                      children: [
                          IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                        Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue ),),
                      ],
                    ),
                    // Add widgets for other details
                  );
                },
              ),
          )
          : null,
                            ),
                            ListTile(
                                title: Row(
                                  children: [
                                    Icon(Ionicons.caret_forward_circle,
                                        color: Colors.black),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Tennis",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                            onTap: () async {
        await fetchTennisSubEvents();
        setState(() {
          isTennisInPlayExpanded = !isTennisInPlayExpanded;
        });
      },
      trailing: isTennisInPlayExpanded && _tennisEvents.isNotEmpty
          ? null
          : null,
      subtitle: isTennisInPlayExpanded
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _tennisEvents.length,
                itemBuilder: (context, index) {
                  String eventTitle = _tennisEvents[index]['event title'];
                  // Access other event details here
                  // ...
                  return ListTile(
                    title: Row(
                      children: [
                          IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                        Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),),
                      ],
                    ),
                    // Add widgets for other details
                  );
                },
              ),
          )
          : null,
                            ),
                          ],
                        ),
                      )
                    : null, // Hide subtitle when collapsed
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle, color: Colors.black),
                    SizedBox(width: 10), // Spacing
                    Text(
                      "Inplay Soon",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  fetchHorseRacingEvents();
                  // Don't navigate to a separate screen
                  // Instead, expand/collapse the nested list
                  _isExpandedHorse =
                      !_isExpandedHorse; // Toggle expansion state

                  // Rebuild the widget to reflect the change
                  setState(() {});
                },

                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust padding if needed
                subtitle: _isExpandedHorse
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          // Nested list when expanded

                          children: [
                            ListTile(
                                title: Row(
                                  children: [
                                    Icon(Ionicons.caret_forward_circle,
                                        color: Colors.black),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Cricket",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () async {
        await fetchCricketEvents();
        setState(() {
          isSoonCricketExpended = !isSoonCricketExpended;
        });
      },
      trailing: isSoonCricketExpended && _cricketEvents.isNotEmpty
          ? null
          : null,
      subtitle: isSoonCricketExpended
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cricketEvents.length,
                itemBuilder: (context, index) {
                  String eventTitle = _cricketEvents[index]['event title'];
                  // Access other event details here
                  // ...
                  return ListTile(
                    title: Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                        Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),),
                      ],
                    ),
                    // Add widgets for other details
                  );
                },
              ),
          )
          : null,
                            ),
                            ListTile(
                                title: Row(
                                  children: [
                                    Icon(Ionicons.caret_forward_circle,
                                        color: Colors.black),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Soccer",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () async {
        await fetchSoccerEvents();
        setState(() {
          isSoonSoccerExpended = !isSoonSoccerExpended;
        });
      },
      trailing: isSoonSoccerExpended && _soccerEvents.isNotEmpty
          ? null
          : null,
      subtitle: isSoonSoccerExpended
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _soccerEvents.length,
              itemBuilder: (context, index) {
                String eventTitle = _soccerEvents[index]['event title'];
                // Access other event details here
                // ...
                return ListTile(
                  title: Row(
                    children: [
                        IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                      Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue ),),
                    ],
                  ),
                  // Add widgets for other details
                );
              },
            )
          : null,
                            ),
                            ListTile(
                                title: Row(
                                  children: [
                                    Icon(Ionicons.caret_forward_circle,
                                        color: Colors.black),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Tennis",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              onTap: () async {
        await fetchTennisSubEvents();
        setState(() {
          isSoonTennisExpended = !isSoonTennisExpended;
        });
      },
      trailing: isSoonTennisExpended && _tennisEvents.isNotEmpty
          ? null
          : null,
      subtitle: isSoonTennisExpended
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _tennisEvents.length,
              itemBuilder: (context, index) {
                String eventTitle = _tennisEvents[index]['event title'];
                // Access other event details here
                // ...
                return ListTile(
                  title: Row(
                    children: [
                        IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                      Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue ),),
                    ],
                  ),
                  // Add widgets for other details
                );
              },
            )
          : null,
                            ),
                          ],
                        ),
                      )
                    : null, // Hide subtitle when collapsed
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "Cricket",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
        await fetchCricketEvents();
        setState(() {
          isCricketNativeExapnded = !isCricketNativeExapnded;
        });
      },
      trailing: isCricketNativeExapnded && _cricketEvents.isNotEmpty
          ? null
          : null,
      subtitle: isCricketNativeExapnded
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cricketEvents.length,
                itemBuilder: (context, index) {
                  String eventTitle = _cricketEvents[index]['event title'];
                  // Access other event details here
                  // ...
                  return ListTile(
                    title: Row(
                      children: [
                          IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                        Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue ),),
                      ],
                    ),
                    // Add widgets for other details
                  );
                },
              ),
          )
          : null,
                            ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "Soccer",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                      onTap: () async {
        await fetchCricketEvents();
        setState(() {
          isSoccerNativeExpanded = !isSoccerNativeExpanded;
        });
      },
      trailing: isSoccerNativeExpanded && _soccerEvents.isNotEmpty
          ? null
          : null,
      subtitle: isSoccerNativeExpanded
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _soccerEvents.length,
                  itemBuilder: (context, index) {
                    String eventTitle = _soccerEvents[index]['event title'];
                    // Access other event details here
                    // ...
                    return ListTile(
                      title: Row(
                        children: [
                            IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                          Text(eventTitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue ),),
                        ],
                      ),
                      // Add widgets for other details
                    );
                  },
                ),
            ),
          )
          : null,
                            ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "Tennis",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
        await _fetchTennisEvents();
        setState(() {
          isTennisExpanded = !isTennisExpanded;
        });
      },
   subtitle: isTennisExpanded
  ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _tennisEvents.length,
        itemBuilder: (context, index) {
          // Ensure data fields exist before accessing them
          final eventTitle = _tennisEvents[index]['event title'] ?? 'Unknown Event';
          // ... access other data fields conditionally

          return ListTile(
            title: Row(
              children: [
                  IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                Text(eventTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            // ...
          );
        },
      ),
    )
  : null,
trailing: isTennisExpanded ? null : null,
  
                            ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "Greyhound today card",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
        await _fetchGreyhoundsEvents();
        setState(() {
          isGreyHoundExpanded = !isGreyHoundExpanded;
        });
      },
       subtitle: isGreyHoundExpanded
      ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _greyEvents.length,
            itemBuilder: (context, index) {
              String eventTitle = _greyEvents[index]['event title']; // Access event title field
              // Access other horse racing event details here
              // ...
              return ListTile(
                title: Row(
                  children: [
                      IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                    Text(eventTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                  ],
                ),
                // Add widgets for other details
              );
            },
          ),
      )
      : null,
  trailing: isHorseRacingExpanded ? null: null,
                            ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Ionicons.caret_forward_circle,
                        color: Colors.black), // Play icon
                    SizedBox(width: 10), // SizedBox for spacing
                    Text(
                      "Horse Racing Today Card",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
        await _fetchHorseRacingEvents();
        setState(() {
          isHorseRacingExpanded = !isHorseRacingExpanded;
        });
      },
       subtitle: isHorseRacingExpanded
      ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _horseEvents.length,
            itemBuilder: (context, index) {
              String eventTitle = _horseEvents[index]['event title']; // Access event title field
              // Access other horse racing event details here
              // ...
              return ListTile(
                title: Row(
                  children: [
                      IconButton(onPressed: () {}, icon: Icon(Ionicons.caret_forward_circle, color: Colors.black,)),
                    Text(eventTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                  ],
                ),
                // Add widgets for other details
              );
            },
          ),
      )
      : null,
  trailing: isHorseRacingExpanded ? null: null,
                            ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 5),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<String?>(
                  future: getroll(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      final userRole = snapshot.data;
                      int length;
                      String isUser = 'user';

                      if (isUser == userRole) {
                        length = listTitle.length - 1;
                      } else {
                        length = listTitle.length;
                      }
                      return ListView.builder(
                        itemCount: length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _navigate.navigateToRoute(listNavigate[index]);
                            },
                            child: Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    leading: Container(
                                      height: height * 0.18,
                                      width: width * 0.18,
                                      child: Image.asset(listImage[index]),
                                    ),
                                    title: Text(
                                      listTitle[index],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    subtitle: Text(
                                      listsubTitle[index],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.006),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey.shade400,
                                  indent: 13,
                                  endIndent: 13,
                                  height: 2,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
