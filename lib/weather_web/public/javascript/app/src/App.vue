<template>
    <div id="app">
        <nav class="navbar navbar-default">
            <span class="navbar-brand text-muted">Weather Web</span>
                <ul class="nav navbar-nav">
                    <li><button class="btn btn-default navbar-btn pull-right"  @click="logout" v-if="current_user">
                        Logout
                    </button></li>
                    <li><p class="navbar-text" v-if="current_user">Signed in as: {{ getUser }}</p></li>
                    <li><button class="btn btn-default navbar-btn" @click='signUp' v-if="!current_user">SignUp</button></li>
                    <li><button class="btn btn-default navbar-btn" @click='logIn' v-if="!current_user">Login</button></li>
                </ul>
        </nav>
        <div v-show="error">
            <transition name="slide-fade">
            <h5> {{error}} <span class="glyphicon glyphicon-remove" @click="error = false"></span></h5>
            </transition>
        </div>
        <div class="jumbotron">
            <p>Hello and welcome to our website. Here you can check the weather on almost every city in the planet.
                You can create an account and add cities that you frequently check into your Favorites. Our website
                gives you the data you want via <a href="http://openweathermap.org/" target="_blank">OpenWeather</a>-API.
                You can check it out their api is free of charge and good for experimenting.The website front-end part
                is powered by VueJs engine, meanwhile at the back-end we use Sinatra with Ruby. It's example project.</p>
        </div>
        <div v-show="!current_user">
        <div v-if="signUpLogIn">
            <div class="form-group">
                <label  for="usr">Username</label>
                <input v-model="credentials.username" type="text" id="usr" class="form-control">
                <label  for="pass">Password</label>
                <input v-model="credentials.password" type="password" id="pass" class="form-control">
                <button class="btn btn-primary" type="submit" @click="submitLogIn">Logon</button>
            </div>
        </div>
        <div v-else="signUpLogIn">
            <div class="form-group">
                <label  for="usr_sign">Username</label>
                <input v-model="credentials.username" id="usr_sign" type="text" class="form-control" >
                <label for="pass_sign">Password</label>
                <input v-model="credentials.password" id="pass_sign" type="password" class="form-control" >
                <label  for="confPass">Confirm password</label>
                <input v-model="credentials.confPassword" id="confPass" type="password" class="form-control">
                <button class="btn btn-primary" type="submit" @click="submitSignUp">SignUP</button>
            </div>
        </div>
        </div>
        <div class="row">
            <favorite v-show="current_user"></favorite>
        </div>

    </div>
</template>
<style>
.slide-fade-leave-active{
    transition: all .3s ease;
}

.slide-fade-enter-active{
    transition: all .8s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}

.slide-fade-enter, .slide-fade-leave-active{
    padding-left: 10px;
    opacity: 0;
}
</style>
<script>
import auth from './auth/auth.js'
import Favorite from './components/Favorite.vue'
import {mapGetters} from 'vuex'

export default {
  data: function() {
        return {
            signUpLogIn: false,
            error: '',
            credentials: {
                username: '',
                password: '',
                confPassword: ''
            },
            current_user: '',
            favorite: {}
            }
    },

  components:{
        Favorite
  },
  methods:{
        mapGetters(){
           view: 'viewUser'
            },
        removeErrorMessage(){
            this.error = false
            },
        submitLogIn(){
            var credentials = {
                  username: this.credentials.username,
                  password: this.credentials.password
                }
            auth.logIn(this,credentials,'/favorites')


            },
        submitSignUp(){
            if(this.credentials.password == this.credentials.confPassword){
                var credentials = {
                    username: this.credentials.username,
                    password: this.credentials.password
                }
                auth.signUp(this,credentials)
                this.getUser()
            }else{
                this.error = "Password field's must be identical"
                }
            },
        logout(){
            auth.logOut(this)
            this.isLoggedIn = false
            this.$router.go('/home')
            },
        logIn(){
            this.signUpLogIn = true

            },
        signUp(){
            this.signUpLogIn = false
            }
        },
  computed:{
        getUser: function(){
            this.current_user = this.$store.state.current_user
            return this.current_user['username']
        }
  }

}

</script>
