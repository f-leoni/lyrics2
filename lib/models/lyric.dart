class Lyric {
  int? id;
  String author;
  String title;
  String lyric;
  String imageUrl;
  String checksum;
  String? album;
  String? lyricUrl;
  int? rank;
  String? correctUrl;

// Constructor
  Lyric({
    required this.id,
    required this.author,
    required this.title,
    required this.lyric,
    required this.imageUrl,
    required this.checksum,
  });

// Create from json object
  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      id: int.parse(json['LyricId']),
      author: json['LyricArtist'] as String,
      title: json['LyricSong'] as String,
      lyric: json['Lyric'] as String,
      imageUrl: json['LyricCovertArtUrl'] as String,
      checksum: json['LyricChecksum'] as String,
    );
  }

// Copy
  Lyric copyWith(
      {int? id,
      String? author,
      String? title,
      String? imageUrl,
      String? lyric,
      String? checksum}) {
    return Lyric(
        id: id ?? this.id,
        author: author ?? this.author,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        lyric: lyric ?? this.lyric,
        checksum: checksum ?? this.checksum);
  }

  static List<Lyric> samples = [
    Lyric(
      id: 1,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
 [Part I: "Lover's Leap" (0:00 - 3:47)]
Walking across the sitting room
I turn the television off
Sitting beside you
I look into your eyes
As the sound of motor cars
Fades in the nighttime
I swear I saw your face change
It didn't seem quite right

And it's, "Hello babe
With your guardian eyes so blue
Hey my baby, don't you know
Our love is true?"

Coming closer with our eyes
A distance falls around our bodies
Out in the garden
The moon seems very bright
Six saintly shrouded men
Move across the lawn slowly
The seventh walks in front
With a cross held high in hand

And it's, "Hey babe
Your supper's waiting for you
Hey my baby, don't you know
Our love is true?"

I've been so far from here
Far from your warm arms
It's good to feel you again
It's been a long, long time

Hasn't it?

[Part II: "The Guaranteed Eternal Sanctuary Man" (3:48 - 5:41)]
I know a farmer who looks after the farm
With water clear, he cares for all his harvest
I know a fireman who looks after the fire

You, can't you see he's fooled you all?
Yes, he's here again
Can't you see he's fooled you all
Share his peace, sign the lease
He's a supersonic scientist
He's a guaranteed eternal sanctuary man

"Look, look into my mouth," he cries
"And all the children lost down many paths
I bet my life you'll walk inside"
Hand in hand, gland in gland
With a spoonful of miracle
He's the guaranteed eternal sanctuary

(We will rock you, rock you little snake)
(We will keep you snug and warm)

[Part III: "Ikhnaton And Itsacon And Their Band Of Merry Men" (5:42 - 9:42)]
Wearing feelings on our faces
While our faces took a rest
We walked across the fields
To see the children of the West
But we saw a host of dark-skinned warriors
Standing still below the ground
Waiting for battle!

Fight's begun, they've been released
Killing foe for peace
Bang, bang, bang, bang, bang, bang
And they're giving me a wonderful potion
'Cause I cannot contain my emotion

And even though I'm feeling good
Something tells me I'd better activate
My prayer capsule

Today is a day to celebrate
The foe have met their fate
The order for rejoicing and dancing
Has come from our warlord

[Part IV: "How Dare I Be So Beautiful?" (9:43 - 11:04)]
Wandering in the chaos
The battle has left
We climb up the mountain
Of human flesh
To a plateau of green grass
And green trees full of life

A young figure
Sits still by a pool
He's been stamped "Human Bacon"
By some butchery tool
He is you

Social Security
Took care of this lad
We watch in reverence
As Narcissus is turned to a flower

(A flower?)

[Part V: "Willow Farm" (11:05 - 15:34)]
If you go down to Willow Farm
To look for butterflies
Or flutter-byes or gutter-flies
Open your eyes
It's full of surprise, everyone lies
Like the fox on the rocks
And the musical box
Oh, there's mum and dad
And good and bad
And everyone's happy to be here

There's Winston Churchill dressed in drag
He used to be a British flag
Plastic bag, what a drag
The frog was a prince
The prince was a brick, the brick was an egg
The egg was a bird
(Fly away you sweet little thing)
(They're hard on your tail)
Haven't you heard?
(They're going to change you)
(Into a human being!)
Yes, we're happy as fish
And gorgeous as geese
And wonderfully clean in the morning

We've got everything, we're growing everything
We've got some in, we've got some out
We've got some wild things floating about
Everyone, we're changing everyone
You name them all, we've had them here
And the real stars are still to appear

(All change!)

Feel your body melt
Mum to mud to mad to dad
Dad-diddley-office, dad-diddley-office
You're all full of ball
Dad to dam to dum to mum
Mum-diddley-washing, mum-diddley-washing
Woo, you're all full of ball
Let me hear your lies
We're living this up to the eyes
Ooh ah, na-na-na
Mama, I want you now

And as you listen to my voice
To look for hidden doors
Tidy floors, more applause
You've been here all the time
Like it or not, like what you got
You're under the soil
(The soil, the soil)
Yes, deep in the soil
(The soil, the soil, the soil, the soil!)
So we'll end with a whistle
And end with a bang
And all of us fit in our places

[Part VI: "Apocalypse In 9/8 (Co-Starring The Delicious Talents of Gabble Ratchet)" (15:35 - 20:50)]
With the guards of Magog, swarming around
The Pied Piper takes his children underground
Dragons coming out of the sea
Shimmering silver head of wisdom looking at me
He brings down the fire from the skies
You can tell he's doing well by the look in human eyes
Better not compromise, it won't be easy

666 is no longer below
He's getting out the marrow in your backbone
And the seven trumpets blowing
Sweet rock and roll
Gonna blow right down inside your soul
Pythagoras with the looking glass
Reflects the full moon
In blood, he's writing the lyrics
Of a brand new tune

And it's, "Hey babe
With your guardian eyes so blue
Hey my baby, don't you know
Our love is true?"

I've been so far from here
Far from your loving arms
Now I'm back again
And babe, it's gonna work out fine

[Part VII: "As Sure As Eggs Is Eggs (Aching Men's Feet)" (20:47 - 23:06)]
Can't you feel our souls ignite?
Shedding ever-changing colours
In the darkness of the fading night
Like the river joins the ocean
As the germ in a seed grows
We've finally been freed to get back home

There's an angel standing in the sun
And he's crying with a loud voice
"This is the supper of the mighty one"
Lord of lords, king of kings
Has returned to lead his children home
To take them to the new Jerusalem""",
      imageUrl:
          "http://ec1.images-amazon.com/images/P/B00104WHLA.02.MZZZZZZZ.jpg",
      checksum: "147b0b3627e1da1a2de60a3c01f84e0f",
    ),
    Lyric(
      id: 2,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
      imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg",
      checksum: "Test002",
    ),
    Lyric(
      id: 3,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
      imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg",
      checksum: "Test003",
    ),
    Lyric(
      id: 4,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
      imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg",
      checksum: "Test004",
    ),
    Lyric(
      id: 5,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
      imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg",
      checksum: "Test005",
    ),
    Lyric(
      id: 6,
      author: "Genesis",
      title: "Supper's Ready",
      lyric: """
[Part I: 'Lover's Leap' (0:00 - 3:47)] Walking across the sitting room 
I turn the television off 
Sitting beside you 
I look into your eyes...""",
      imageUrl: "assets/B000VDDCRE.01.MZZZZZZZ.jpg",
      checksum: "Test006",
    ),
  ];
}
