## 1. Make github Repository in github

## 2. New project from the github repository

## 3. Install and run blogdown
install.packages(c("blogdown", "usethis", "credentials"))
library(blogdown)
install_hugo() # hugo 설치: only once
new_site() # New site
new_post("KKK", ext = ".Rmd")
serve_site() # Update site

## 4. Push to githug repository

# For new github user: Github pat
usethis::use_git_config(user.name = "Jinseob Kim", user.email = "jinseob2kim@gmail.com")
install.packages("usethis")
usethis::create_github_token() 
credentials::set_github_pat()

## 5. Sign up: https://www.netlify.com/ 

## 6. Add new site -> Import an existing project -> Connect with github -> select repository -> Deploy site