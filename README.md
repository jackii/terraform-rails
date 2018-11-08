# Ruby on Rails


## 1. Setup Ruby on Rails

- use `rbenv` or `rvm` as ruby version manager
- use latest version of Rails (5.2.1)
- use postgresql
- use reactjs
- use git

1. Create new project

```
rails new project_name -d postgresql --webpack=react
```

2. Setup database

```
rails db:setup
rails db:migrate
```

3. Create `index_controller.rb` to make sure Rails is running on localhost


