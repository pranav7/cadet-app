![Cadet](https://i.imgur.com/EBM5EFv.png)


## Dev Set up

**Install `rvm`**

```bash
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

Follow the post install instructions to source rvm and get started.

**Install Ruby version `2.4.1`**

```bash
rvm install 2.4.1
```

**Install Postgresql & Redis**

```bash
brew install postgresql
brew install redis
```

**Install Yarn**

```bash
brew install yarn
```

**Copy Config Files**

```bash
cp cadet_config.example.yml cadet_config.yml
cp secrets.example.yml secrets.yml
```

**Install Bundler**

```bash
gem install bundle
```

```bash
bundle install
```

**Install Packages**

```bash
yarn install
```

**Create Database & Migrate**

```bash
rails db:create
rails db:migrate
```

**Run Sidekiq & Rails Server**

```bash
bundle exec sidekiq -q default -q mailers
bundle exec rails server
```
