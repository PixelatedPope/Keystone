<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![project_license][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <img src="images/logo.png" alt="Logo" width="315" height="250">

  <p align="center">
    Pixel Perfect Projection Plugin
    <br />
    <a href="https://github.com/PixelatedPope/Keystone"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/PixelatedPope/Keystone">View Demo</a>
    &middot;
    <a href="https://github.com/PixelatedPope/Keystone/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/PixelatedPope/Keystone/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#features">Features</a></li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About Keystone

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Keystone is a tool to help make your game look its best on any monitor! With a variety of options and settings, Keystone allows you or the player to customize the way your game renders for an ideal experience.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- Features -->
## Features
![Static Badge](https://img.shields.io/badge/Made_With_%26_For-GameMaker_2024+-green?style=flat-square&logo=gamemaker&logoColor=white)
### Game Resolution Made Easy
* Plug in the desired resolution for your game, and feel confident it will scale and look beautiful on almost any display resolution!
* Control the resolution of your game easily. Want a crunchy, retro pixel aesthetic? Or do you want everything to be as smooth as possible? Either is easy to enable with Keystone!
### Bilinear Filtering
* With a single setting, enable a bilinear filter that smooths out imperfect scaling while retaining sharp pixel visuals. A process used in games like Sonic Mania!
### Pixel Perfect Scaling
* Want your game rendered perfectly? Enable the Perfect Scale setting, and your game will be rendered as large as possible on the current display while still only scaling in whole number multiples. You can even draw a custom mat graphic behind it (as seen in the above screenshot)
* If you've ever attempted something like this yourself, you may have noticed that changing where the application surface renders in your game window will break several GM features. Mouse coordinates and the GUI layer will no longer line up with your game. Keystone includes functions to correct for these issues. 
### Simulate Display Sizes
* Curious what your game would look like on a 1280 x 720 display, but don't have one handy? What about a vertical display? Plug in the resolution you want to test with and run your game in borderless mode to see exactly how it would render on that display!
### GUI Surface
* When using Keystone, all gui events draw to a surface. This means you can control the actual pixel resolution more easily for crunchy retro UIs, as well as apply post processing effects like CRT shaders or the included bilinear filter (applied as necessary to the gui surface by default)
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Installation

1. Download the  [YYMPS](releases/)
2. Drag and drop it into your project
3. Put an instance of obj_keystone_manager in the first room of your game.
   1. Customize the Keystone Settings struct in the manager's create event to fit your desired options.
4. If necessary, remove any other code you had that was trying to manage your resolution stuff (like the room start event for the camera object from my old GMS2 Camera Tutorial)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Mobile and Web Support
- [ ] Downscaling HD Games with SSAA
- [ ] Post Processing Effect Examples
    - [ ] Option to merge App Surface and Gui surface for single pass effect rendering (Such as a CRT shader)

See the [open issues](https://github.com/PixelatedPope/Keystone/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Top contributors:

<a href="https://github.com/PixelatedPope/Keystone/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=PixelatedPope/Keystone" alt="contrib.rocks image" />
</a>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Jon Peterson (Pixelated Pope) - [@pixelatedpope.bsky.social](https://bsky.app/profile/pixelatedpope.bsky.social) - pixelated_pope@hotmail.com

Project Link: [https://github.com/PixelatedPope/Keystone](https://github.com/PixelatedPope/Keystone)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* Demo uses [ImGui_GM by nomiin](https://github.com/nommiin/ImGui_GM)
* Shaders written by [Mytino](https://marketplace.gamemaker.io/publishers/307/mytino)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/PixelatedPope/Keystone.svg?style=for-the-badge
[contributors-url]: https://github.com/PixelatedPope/Keystone/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/PixelatedPope/Keystone.svg?style=for-the-badge
[forks-url]: https://github.com/PixelatedPope/Keystone/network/members
[stars-shield]: https://img.shields.io/github/stars/PixelatedPope/Keystone.svg?style=for-the-badge
[stars-url]: https://github.com/PixelatedPope/Keystone/stargazers
[issues-shield]: https://img.shields.io/github/issues/PixelatedPope/Keystone.svg?style=for-the-badge
[issues-url]: https://github.com/PixelatedPope/Keystone/issues
[license-shield]: https://img.shields.io/github/license/PixelatedPope/Keystone.svg?style=for-the-badge
[license-url]: https://github.com/PixelatedPope/Keystone/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png


[Gamemaker]: https://img.shields.io/badge/Made_With_GameMaker-green?style=flat-square&logo=gamemaker&logoColor=white

[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
