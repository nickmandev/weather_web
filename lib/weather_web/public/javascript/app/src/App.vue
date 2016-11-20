<template>
    <div id="app">
        <nav class="navbar navbar-default">
            <span class="navbar-brand text-muted">Weather Web</span>
                <div v-if="isLoggedIn">
                    <ul class="nav navbar-nav">
                        <li><button class="btn btn-default navbar-btn pull-right" @click="logout">Logout</button></li>
                        <li><router-link to="/favorites">Favorites</router-link></li>
                        <li><p class="navbar-text">Signed in as: {{ current_user["username"] }}</p></li>
                    </ul>
                </div>
                <div v-else>
                    <ul class="nav navbar-nav">
                        <li><router-link to="/signup">SignUp</router-link></li>
                        <li><a @click='logIn'>Login</a></li>
                    </ul>
                </div>
        </nav>
        <div v-if="error">
            <h5> {{error}}</h5>
        </div>
        <div class="jumbotron">
            <p>Hello and welcome to our website. Here you can check the weather on almost every city in the planet.
                You can create an account and add cities that you frequently check into your Favorites. Our website
                gives you the data you want via <a href="http://openweathermap.org/" target="_blank">OpenWeather</a>-API.
                You can check it out their api is free of charge and good for experimenting.The website front-end part
                is powered by VueJs engine, meanwhile at the back-end we use Sinatra with Ruby. It's example project
                with no intend to became public.</p>
        </div>
        <div v-if="showLogIn">
            <div class="form-group col-xs">
                <label  for="usr">Username</label>
                <input v-model="credentials.username" type="text" id="usr" class="form-control">
                <label  for="pass">Password</label>
                <input v-model="credentials.password" type="password" id="pass" class="form-control">
                <button class="btn btn-primary" type="submit" @click="submit">Logon</button>
            </div>
        </div>
        <router-view></router-view>
    </div>
</template>

<script>
import auth from './auth/auth.js'

export default {

  data: function() {
        return {
            isLoggedIn: false,
            error: false,
            message: '',
            showLogIn: false,
            credentials: {
                    username: '',
                    password: ''
                },
            current_user: '',
            }
    },
  methods:{

        removeErrorMessage(){
            this.error = false
            },
        submit(){
        var credentials = {
                  username: this.credentials.username,
                  password: this.credentials.password
                }
            auth.logIn(this,credentials)
            this.showLogIn = false

        },
        logout(){
            auth.logOut(this)
            this.isLoggedIn = false
            },
        logIn(){
            this.showLogIn = !this.showLogIn

        },
        }

}


</script>
