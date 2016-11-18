<template>
    <div id="app">
        <nav class="navbar navbar-default">
            <span class="navbar-brand text-muted">Weather Web</span>
            <ul class="nav navbar-nav">
                <div v-if="isLoggedIn">
                    <li>
                        <button class="btn btn-default navbar-btn" type="submit" @click="logout">Logout</button>
                    <li>
                </div>
                <div v-else>
                    <div v-if="toogled">
                        <button class="btn btn-default navbar-btn" type="submit" @click="toogle">SignUP</button>
                    </div>
                    <div v-else>
                        <li><button class="btn btn-default navbar-btn" type="submit" @click="toogle">Login</button></li>
                    </div>

                </div>
            </ul>
            <div v-if="isLoggedIn">
                <p class="navbar-text">Signed in as: {{ auth_user }}</p>
            </div>
            <div v-else>
                <div class="navbar-form navbar-right">
                    <div v-if="toogled">
                    <div class="form-group">
                        <input v-model="username" type="text" id="usr" class="form-control" placeholder="Username">
                        <input v-model="password" type="password" id="pass" class="form-control" placeholder="Password">
                        <button class="btn btn-default" type="submit" @click="submit">Logon</button>
                    </div>
                    </div>
                    <div v-else>
                    <div class="form-group">
                        <input v-model="username" type="text" class="form-control" placeholder="Username">
                        <input v-model="password" type="password" class="form-control" placeholder="Password">
                        <input v-model="confPassword" type="password" class="form-control" placeholder="Confirm password">
                        <button class="btn btn-default" type="submit" @click="signUp">SignUP</button>
                    </div>
                    </div>
                </div>
            </div>
        </nav>
        <div v-show="error">
           <h5> {{errorMessage}} <span @click="removeErrorMessage" class="glyphicon glyphicon-remove"></span>  </h5>
        </div>
        <div class="jumbotron">
            <p>Hello and welcome to our website. Here you can check the weather on almost every city in the planet.
            You can create an account and add cities that you frequently check into your Favorites. Our website
            gives you the data you want via <a href="http://openweathermap.org/" target="_blank">OpenWeather</a>-API.
            You can check it out their api is free of charge and good for experimenting.The website front-end part 
            is powered by VueJs engine, meanwhile at the back-end we use Sinatra with Ruby. It's example project
            with no intend to became public.</p>
        </div>
        <div>
        </div>
    </div>
</template>

<script>
export default {
  name: 'app',
  data: function() {
       return {
       toogled: true,
       isLoggedIn: false,
       error: false,
       message: '',
       username: '',
       password: '',
       confPassword: '',
       auth_user: ''
       }
    },
  methods:{
        toogle(){
            this.toogled = !this.toogled
            },
        submit(){
            var data = {username: this.username,pass: this.password}
                this.$http.post('/api/login', data).then(function(data){
                   this.loggedIn(data.body)
                },(response)=>{
                    console.log('fail')
                })
            },
        loggedIn(json){
            var data = JSON.parse(json)
                this.auth_user = data["username"]
                this.isLoggedIn = true;
                console.log(this.auth_user)
            },
        signUp(){
            if(this.password == this.confPassword){
                var data = {username: this.username, pass: this.password}
                this.$http.post('/api/sign_up',data).then(function(data){
                   this.message = 'Account created successfully'
                   this.error = true
                },(response)=>{
                    console.log('fail')
                })
            }else{
                this.error = true
                this.message = "Passwords fields must be identical!"
            }
        },
        removeErrorMessage(){
            this.error = false
        }
    }

}

</script>

<style>

</style>
