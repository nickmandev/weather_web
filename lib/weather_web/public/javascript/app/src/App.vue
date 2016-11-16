<template>
    <div id="app">

        <div>
            <router-link to="/login">Logon</router-link>
                <p>Hello and welcome to our website. Here you can check the weather on almost every city in the planet.
                You can create an account and add cities that you frequently check into your Favorites. Our website
                gives you the data you want via <a href="http://openweathermap.org/" target="_blank">OpenWeather</a>-API.
                You can check it out their api is free of charge and good for experimenting.</p>
        </div>
        <div>
            <router-view></router-view>
        </div>
    </div>
</template>

<script>
export default {
  name: 'app'

}
</script>

<style>

</style>
