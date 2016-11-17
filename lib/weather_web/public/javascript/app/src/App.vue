<template>
    <div id="app">
        <nav class="navbar navbar-default">
            <span class="navbar-brand text-muted">Weather Web</span>
            <ul class="nav navbar-nav">
                <li><router-link to="/home">Index</router-link></li>
                <li><router-link to="/login">Logon</router-link></li>
                <li><router-link to="/signup">SignUp</router-link></li>
            </ul>
            <span class="pull-rigth"
        </nav>
        <div class="jumbotron">
            <p>Hello and welcome to our website. Here you can check the weather on almost every city in the planet.
            You can create an account and add cities that you frequently check into your Favorites. Our website
            gives you the data you want via <a href="http://openweathermap.org/" target="_blank">OpenWeather</a>-API.
            You can check it out their api is free of charge and good for experimenting.The website front-end part 
            is powered by VueJs engine, meanwhile at the back-end we use Sinatra with Ruby. It's example project
            with no intend to became public.</p>
        </div>
        <div>
            <router-view></router-view>
        </div>
    </div>
</template>

<script>
export default {
  name: 'app',
  data: function(){
        return user: ''
  }
}
</script>

<style>

</style>
