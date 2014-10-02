JKCustomizedCollectionView
==========================
<p>
<img src='http://jayeshkawli.com/CustomCollectionViewImages/MainPage.png'>
</p><p>
<img src='http://jayeshkawli.com/CustomCollectionViewImages/ImageInfo.png'>
</p><p>
<img src='http://jayeshkawli.com/CustomCollectionViewImages/PhotographerInfo.png'>
</p><p>
<img src='http://jayeshkawli.com/CustomCollectionViewImages/FullImageView.png'>
</p><p>


This is simple implementation of Pinterest presentation style using iOS provided UICollectionView framework

I am using Simple <i>iOS Collection view</i> and <i>UICollectionViewFlowLayout</i> to layout cell height and position based on the content length. Length of cell is determined by the length of content and image is scaled down to fit the width of given cell maintaining aspect ratio at the same time.

Project uses following <i>500px API</i> to fetch Photograph and relevant metadata of image itself and author.

https://apigee.com/vova/embed/console/api500px

<p>
There are various parameters user can control to see flow of images on screen
<br/><br/>
1. Page number<br/>
2. Number of Images to download (Maximum value is 100. If input value is greater than this, just default to 100)<br/>
3. Keywords - Specifies the keywords to search images for
</p>
<p>
Each image along with following small set of parameters is then displayed on the screen

<br/><br/>
1. Name of photographer<br/>
2. Date on which photograph was clicked<br/>
3. Image title<br/>
4. Description<br/>
<br/>

</p>

Each image is overlayed with an invisible button which will trigger magnified version of the image. (This appearance is animated to appear as if coming out from the touch point)
<b>Application also uses newly introduced spring animation to present custom views on screen. </b>

<p>
In addition to it, for each image on collection view cell is provided with two buttons
<br/><br/><br/>
<b>1. Image information</b>
   Contains image metadata such as camera info, apearature size, focal length, number of favorites count for image and geolocations information if available etc. Available values are marked with checkmark to signify existence of their values from an API
<br/>
<b>2. Photographer information</b>
   Contains photographer metadata such as country of origin, city, user name, first and last name and number of followers etc.
</p>



<b>Note:</b>

<i>
This application is currently supported only for iPads in Landscape orientation. However, I am currently working on providing portrait support as well. I am using iOS feature Autolayout to achieve this. It is somewhat tricky and I am still new to it. So, it might take a while for me to post portrait version of this app.

Also, feel free to download and experiment with the code. If there are any bugs or feature requests they are more than welcome.
</i>
