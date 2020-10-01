# UI automation

This is a project to run the UI automation through the Watir Driver and cucumber. It follows the page object model.

This project also contains the option to run the driver through Interactive Ruby(irb), so allow a developer to play with the automation in a sandbox.

# Requirements

Ruby

# Running Tests

Running tests is fairly simple. First, make sure you are in the project root directory.
 
 Next, install the Ruby gem "bundler" if you have not done so already using the gem install command:
>gem install bundler

Install the the project gem third party dependincies next using bundler:
>bundle install

One of those dependencies is cucumber. To run a test, we need to run cucumber with two things in mind:

- We need to run in the bundle context, where we loaded our third party dependencies
- We need to load Cucumber within an environment

To do both of these and run our tests, we use one command:
>bundle exec cucumber -r cucumber_env.rb

"bundle exec" runs cucumber in our bundle context, while "-r cucumber_env.rb" requires/loads the dependencies within our project. Internal dependencies include things like the feature files themselves, step definitions, as well as, again, our third party dependencies(bundle sets up our dependencies within Ruby, we still need to pull them into our project by loading them in our environment).

#Running a subset of tests

To run a subset of tests, we will need to setup test profiles within the cucumber.yml file.

There, we can setup up profiles that contain all of our cucumber parameters(run the command cucumber --help to see available paramters).

For example, if we want to run tests with certain parameters, instead of sending those everytime we run a command, we store them under a profile in the cucumber.yml:
>sample_profile: -r support/cucumber_env.rb -t '@regression' 

Now, to run tests that require our env file AND only run tests with the tag "@regression", we simply need to use the command:
>bundle exec cucumber -p sample_profile

# Starting the IRB Sandbox
To start the irb sandbox, we will need to do three things once we cd into the project directory:
 
 1. Once in the project directory, install the gem bundler if you have not done so already:
 
    >gem install bundler
 
 
 2. Next, we need to run 
    >bundle install
    
    This will install the gems we have in our Gemfile.  This gems are code libraries that our project needs to actually run. Make sure in the Gemfile you have the gem "rake"
    
    
 3. Once we have installed our gems we can start the sandbox.  To do this for a ruby mac setup, all we need to do is run:
    >bundle exec rake
    
    For Jruby setup, try the following command:
    
    >jruby -S irb -r \**insert path to irb_env.rb*\*
    
    
    
   This will run the "browser:start" rake task(we do not need to specify the rake name because it is the default for this project).
    
   The rake task will load all everything in the support/irb_env and support/common_env files.
    
   Think of them as the "environments" you're loading the sandbox in. The environments act as the context of your project, and specify what modules/classes/methods you have access to.
    
   common_env is shared by the irb_env and the cucumber_env.
    
    
    
  That's how you start the sandbox! Now let's use it.
  
  #Parallel Testing:
  To run tests in parallel:
  
  >bundle exec parallel_cucumber features/ -n 5 -o '-t @only -r support/cucumber_env.rb -r features'
    
 For reporting, you have to be a little creative aggregating reports. Jenkins has a useful plugin to gather and combine cucumber reports in json, but it is still up to you to make sure parallel reports aren't overwritten by each other.
 
 Here is an example of reports that won't overwrite each other for your cucumber.yml
 
 >--format json --out=reports/REPORT_<%= Random.new_seed%>_<%= Time.now.strftime('%Y_%m_%d_%H_%M')%>.json

The name is a mess, but it doesn't matter in this case.
    
    
 # Using the sandbox
 
 Once you're in the sandbox, try entering:
 
 >start
 
 This will create an instance of a Google Chrome browser.  This browser is being controlled by the Watir webdriver.
 
 Next, we might want to navigate to the Google home page. Let's try running this command:
 
 >  page = GoogleHomePage.new @browser
 >  @browser.goto page.url_for_page
 
 What does this command actually do? Several things.
 
 First, we will immediately notice the browser we opened with our start command will navigate to the google home page. The visit_page method has found our Watir instance of the browser and navigated to the url in the page-object GoogleHomePage.
 
 Now visit_page has not only navigated us to a page, it has also loaded up the page-object of the url we navigated to. We have loaded them into the variable **page**.
 
 'page' is now our our page object, and contains all the dom/html elements of the Google Home Page.
 
 To see what I mean, lets try two commands.
 
 >google_search_bar = page.text_fields.first
 
 and
 
 >google_search_bar.flash
 
 What happened? Well simply on the browser the Google search bar flashed red for a very brief instant. You might not have seen it, so I suggest running that last command once while paying attention to the browser.
 
 Overall, we assigned an element value from our page object to google_search_bar. Specifically, we took all the text_fields from the google page in the form of an array, grabbed the first one, and assigned it to our variable.  In this case, the Google home page only has one text field, so we knew what we were going to get.
 
 In the next command, we used built in function to make the text field element we grabbed flash.
 
 **Do not worry if you do not understand this right away.  We will break this down in the next section. Right now we just need to get you familiar with the sandbox**
 
 page-object/watir have a lot of built in functions to play with(like flash), so you can see how we can use this sandbox to see what we're working with in a page object!
 
 
 # Understanding a page object: elements
 
Pages in the page object model are the basic building blocks of our automation and are made up of two parts: elements and methods. Let's look back at what we did in the previous section:

>page = visit_page(GoogleHomePage)

What is GoogleHomePage? GoogleHomePage is our page object. 

Elements are the html elements of the web page.  Page object translates these html elements into Ruby objects. For example, if you navigate to browser_page_models/google_home_page.rb of this project, you will see:

>link(:about_link, text: 'About')

What is happening here? We are taking a link element with the text value "About" and naming it "about_link".

Now, anytime I reference:

>GoogleHomePage.about_link_element

I am referring to that element. **DO NOT FORGET THE "_element" PART"**

Now, open the sandbox, try "page = visit_page(GoogleHomePage)", and then try some of these:

>page.about_link_element.exist?

>page.about_link_element.flash

>page.about_link_element.visible?

These are all methods you will use a lot in your automation when you interact with elements. More about these later!

# Understanding a page object: methods
 
 # Watir
 
 https://www.rubydoc.info/gems/watir-webdriver/Watir
 
 # Accessibility
 
 Here is how we currently test accessibility again the WCAG 2.0 compliance standard:
 
 >https://confluence.oclc.org/display/WDD/Accessibility+Audits
 
 The important things to note from this document are two things: we use VPAT to score compliance, and SiteImprove provides a way to report accessibility scores in a VPAT for the business.
 
 If you check the way this project checks for accessibility errors in AcheckerPage.rb, you note there is no mention of SiteImprove or VPAT.  ***This is because the accessbility automatation in this project is not a direct substitute for checking accessbility.***
 
 While both SiteImprove and Achecker will let you determine if a website has WCAG error or is compliant, when reporting to the business you will need to use SiteImprove.
 
 # Accessibility: Achecker
 
 Achecker is a free tool that allows you to check your websites compliance in a variety of ways.  This project uses the html markup feature specifically to test for compliance.
 
 We do this relatiely simply: the Watir class has a method call .html(for example @browser.html) that allows you to grab the html source from a page. 
 
 When we navigate to a page we want to check for accessbility, we simply grab the source using this method, and paste it into Achecker.  After we check the source, we check the browser for the compliance element, If it is there, the test will pass/we are compliant. Otherwise, the test will fail/we are not compliant.
 
 That's it!
 
 
 
 
 
 
