# Project 6 - *Fiestagram*
![fiestagram_logo small](https://cloud.githubusercontent.com/assets/11231583/23840925/ada50bd2-077f-11e7-9a20-d32d0f1c046d.png)
**Fiestagram** is a photo sharing app using Parse as its backend.
No real party inside. Simply an Instagram clone. With lots of confetti.

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"

The following **optional** features are implemented:

- [X] Show the username and creation time for each post
- [X] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [X] User Profiles:
   - [X] Allow the logged in user to add a profile photo
   - [X] Display the profile photo with each post
   - [X] Tapping on a post's username or profile photo goes to that user's profile page

The following **additional** features are implemented:

- [X] UI enhancement
- [X] Edit bio and profile image from  only current profile view; profile view extends other users and their posts.
- [X] Confetti view for a spark of fiesta
- [X] Liking functionality semi implemented
- [X] Gallery or Camera options
- [X] Edit images and can apply filters on them! (Four different filters excluding the original image)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Commenting functionality
2. Stronger structures for back-end management

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

![fiestagif3](https://cloud.githubusercontent.com/assets/11231583/23840914/8cf55982-077f-11e7-8d42-e9145037639b.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
A challenge I had when it came to displaying the information for the profile view for other users was that the user pointer object did not give me access to that user's information, just their username/id; to circle around this, I called a separate query using the username to access the user information directly.


## License

    Copyright [2017] [Steven Hurtado]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
