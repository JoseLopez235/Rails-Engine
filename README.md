# <div align="center"> Rails Engine

## Description
"Rails Engine" is an API that I created that allows us to see a merchant, a customer, an invoice, a transaction, items and an invoice item which all come together to make an api that shows you merchants transactions, they items they sell with the price and quantity they sold to their customers. It allows us to peek inside the merchants numbers to see how much revenue a specific merchant made or all together.

Rails Engine is an Api created from scratch which is new to me and uses CRUD functionality. Users can consume the Api to grab information from a specific merchant or many merchants and as well as see there items that each merchant sells. Users can aslo create, update or even delete an item or merchant to there liking.

Students worked remotely over 10 days using Slack, Zoom, Github, and Github projects. Test-driven development drove the creation of the app with tests written in RSpec. Here is our coverage, we used RSpec for our testing: 

<img src="https://mail.google.com/mail/u/0?ui=2&ik=0cfbc745ad&attid=0.1.1&permmsgid=msg-f:1686392304263275346&th=176744dda790a352&view=fimg&sz=s0-l75-ft&attbid=ANGjdJ_nCmit9uLcP_tWXT34c6T8kPwTMyyJ8mYHw00nKT4Aw7CfrUxxCJvQNtjYQpFk06tOJrDGLSY3iNyGigvhM1s_pTK_J0xCjfjZVlBe8ScCLprMfbj7U_EA-io&disp=emb" alt="Screen-Shot-2020-12-10-at-10-04-10-AM" border="0">

## Our Database Strcuture
<img src="https://i.ibb.co/jw8F8wF/Screen-Shot-2020-12-10-at-10-03-05-AM.png" alt="Screen-Shot-2020-12-10-at-10-03-05-AM" border="0">

## Instructions
Our applicaiton is hosted on [Heroku](https://viewing-party-2008-be.herokuapp.com/), where you'll be able to view its functionality to the fullest.
For usage on your local machine follow the instructions listed below:
```
git clone git@github.com:SageOfCode/viewing_party.git
cd viewing_party
bundle install
rake db:{drop,create,migrate,seed}
rails server
visit localhost:3000 in your web browser
```
## Statistics
   ![](https://img.shields.io/badge/Rails-5.2.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)    ![](https://img.shields.io/badge/Code-HTML-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a) ![](https://img.shields.io/badge/Code-CSS-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Code-Ruby-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
