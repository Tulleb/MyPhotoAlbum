# MyPhotoAlbum
French job interview project

## Installation
- Copy sources,
- Install CocoaPods,
- `pod install` from the project folder,
- Run MyPhotoAlbum.xcworkspace.

## Version
1 (0)

## Comments
Time was the biggest problem on this project. Everything is easely doable, but the given time is very short.
Also, I started a bit late because of a family lunch that I didn't planed (sorry being late). I know this isn't an excuse but I just wanted to point that out.

I succeed to build the online part of the project, but the offline isn't achieved: there is still an issue I didn't fix in the "savePhoto" function.

I used MVC architecture (didn't took time to think about something else).

Also, I needed more time to add unit testing.

I choosed Alamofire and ObjectMapper libraries because it's the most supported from far at the moment, on open sourced Swift repositories.
Didn't have time to use another repo to improve design or to add activity indicators (while request are downloading).

To work out offline, I kept in mind the every download were not interrupted.

Most difficult part of the challenge was time, without hesitation.

I consider that I have done 70% of the project so far, considering 5% of offline photo issue, and 25% of test unit which I didn't do at all.
It would take me around 1h30 to have a reliable first version.
