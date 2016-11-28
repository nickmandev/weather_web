<template>
    <div id="app" class="container-fluid">
        <div class="row">
            <nav class="navbar navbar-default">
                <div class="col-xs-4">
                    <span class="navbar-brand text-muted">Weather Web</span>
                    <button class="btn btn-default navbar-btn" @click='signUp' v-if="!current_user">SignUp</button>
                    <button class="btn btn-default navbar-btn" @click='logIn' v-if="!current_user">Login</button>
                </div>
                <div class="form-group has-feedback col-xs-4">
                    <input type="text" v-model="city" @keyup.enter="commit(city)"
                           class="form-control navbar-btn" id="search" placeholder=" To search press Enter...">
                    <span class="glyphicon glyphicon-search form-control-feedback navbar-btn" id="search-btn"></span>
                </div>
                <div class="col-xs-4"  v-show="current_user">
                    <button class="btn btn-default navbar-btn logOut"  @click="logout" v-if="current_user" >
                        Logout
                    </button>
                    <span class="navbar-text logOut" v-if="getUser">Signed in as: {{ getUser }}</span>
                </div>

            </nav>
        </div>
        <div v-show="error">
            <transition name="slide-fade">
            <h5> {{error}} <span class="glyphicon glyphicon-remove" @click="error = false"></span></h5>
            </transition>
        </div>
        <div>
            <search></search>
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

span .form-control-feedback {
    width: 10%;
}

#search {
    padding: 0;
    padding-right: 35px;
    width: 1%;
    -webkit-transition: width 1s ease-in-out;
    -moz-transition: width 1s ease-in-out;
    -o-transition: width 1s ease-in-out;
    transition: width 1s ease-in-out;
    float: right;
}

#search:focus{
    width: 80%;
}


.form-group {
    margin: 0px;
    padding: 0px;
}

.logOut{
    float: right;
}


</style>
<script>
import auth from './auth/auth.js'
import Favorite from './components/Favorite.vue'
import Search from './components/Search.vue'

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
            favorite: {},

            }
    },

    components:{
        Favorite,
        Search
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
            },
        commit: function(city){
            this.$store.commit('setCityName',city)
        }
        },
    computed:{
        getUser: function(){
            this.current_user = this.$store.state.current_user
            return this.current_user['username']
        }
    },

    watch:{
        current_user: function getFavorites(){
            var id = this.$store.state.current_user.id
            this.$http.get('http://localhost:9292/api/forecast',{params:{'id':id}} ).then(function(data){
                this.$store.commit('setFavorites',data.body['favorites'])
            }),(response) => {
                console.log(response)
            }

         },


    }


}

</script>
