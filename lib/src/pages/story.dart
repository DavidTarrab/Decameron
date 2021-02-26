import "package:flutter/material.dart";
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";

class StoryPage extends StatefulWidget {
	final Story story;
	const StoryPage(this.story);

	@override
	StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {

	bool showTranscript = false;

	Future<ChewieController> controllerFuture;

	@override
	void initState() {
		super.initState();
		controllerFuture = getController();		
	}

	Future<ChewieController> getController() async {
		final String url = await Models.instance.stories.getVideoUrl(widget.story);
		final VideoPlayerController controller = 
			VideoPlayerController.network(url);
		await controller.initialize();
		return ChewieController(videoPlayerController: controller);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("View story")),
		body: ListView(
			children: [
				AspectRatio(
					aspectRatio: 1.5, 
					child: FutureBuilder<ChewieController>(
						future: controllerFuture,
						builder: (_, AsyncSnapshot snapshot) => snapshot.hasData
							? Chewie(controller: snapshot.data)
							: const CircularProgressIndicator(),
					)
				),

				Center(
        				child: Container(
						constraints: const BoxConstraints(maxWidth: 750),
						child: ListView(
							padding: const EdgeInsets.all(10),
							children: [
              
              					Padding(
                					padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
               						child: Text(
                  						"My Smaple Story",
										textAlign: TextAlign.center,
                  						style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)
							    	)
              					),
              
              					Padding(
                					padding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                					child: TextButton(
                  						onPressed: () {},
                  						child: Text(
                    						"by Smaple Author",
                    						textAlign: TextAlign.center,
                    						style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey)
                  						)
                					)
              					),
              
              					Padding(
              						padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                					child: Text(
                  						"Smaple big sentence...",
                  						textAlign: TextAlign.center,
                  						style: TextStyle(color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold)
                					)
              					),
              
              					Padding(
                					padding: EdgeInsets.fromLTRB(20, 20, 20, 2),
                					child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOaZihifkPu3rKcKOLIWSu7KJRAV2LHayChA&usqp=CAU')
              					),
              
              					Padding(
              						padding: EdgeInsets.fromLTRB(20, 2, 20, 20),
                					child: Text(
                  						"12/26/2020",
                  						textAlign: TextAlign.left
                					)
              					),
              
              					Padding(
                					padding: EdgeInsets.fromLTRB(20, 120, 20, 20),
                					child: ElevatedButton(
                  						onPressed: () {
                    						setState(() {
                      							showTranscript = !showTranscript;
                    						});
                  						},
                  						child: Text(
                    						"Show Transcript",
                    						textAlign: TextAlign.center
                  						)
                					)
              					),
                
              					showTranscript ? Padding(
                					padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                					child: Text(
                  						"smaple: I can't do this alone Even though I am strong Need something more than me Someone to push me to victory Let's see what we can do Together me and you Can't be afraid to try Kiss your fears goodbye No looking back You and I we're on the attack Full speed ahead Run into the sunset Such a different feeling The both of us believing We can make it better Together we can show the world what we can do You are next to me, and I'm next to you Pushing on through until the battles won No ones gonna get nothing to us Into each other we put our trust Standing united, after the fight All alone we will never be The two of us, are holding the key We see today, what we couldn't see Before I say goodbye to you one more last fist bump I know you have been afraid before But you don't have to be anymore No more emptiness to feel inside When we run together no one can break up our strides No looking back You and I we're on the attack Full speed ahead Run into the sunset Such a different feeling The both of us believing We can make it better Together we can show the world what we can do You are next to me, and I'm next to you Pushing on through until the battle's won No ones gonna get nothing to us Into each other we put our trust Standing united, after the fight is done We can show the world what we can do You are next to me and I'm next to you Pushing on through until the battles won No ones get nothing to us Into each other we put our trust Standing united after the fight It's a brand new day We have turned the page Never knew how much I needed Somebody to help me this way All alone we will never be The two of us, are holding the key We see today, what we couldn't see Before I say goodbye to you one more last fist bump",
                  						style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                					)
              					) : Container()
                
              				]
            			)
					)
				)
		    ]
		)
	);
}
