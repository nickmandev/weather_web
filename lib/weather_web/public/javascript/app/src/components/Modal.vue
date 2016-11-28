<template>
<div id="modal">
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container">
            <div class="modal-header">
                <button class="btn btn-default btn-xs modal-default-button" @click="$emit('close')">X</button>
                <h4>Type the name of the city you want to add to Favorites, then click on the
                <span class="glyphicon glyphicon-plus"></span> to add it.</h4>
            </div>
          <div class="modal-body">
              <input type="text" class="form-control" placeholder="Press Enter to search..." v-model="cityName" @keyup.enter="searchCity">
              <ul class="list-group" v-show="results">
                <li class="list-group-item" v-for="res in results">
                    <h4> {{res.city_name}}, {{res.country}}, Lat: {{res.latitude}}, Long: {{res.longitude}}
                        <span class="glyphicon glyphicon-plus pull-right" @click="addCity(res)"></span>
                    </h4>
                </li>
              </ul>
          </div>

          <div class="modal-footer">
            <div name="footer">
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</div>
</template>

<script>
import auth from '../auth/auth.js'
    export default{
        name: 'modal',
        template: '#modal',
        data: function(){
            return{
                cityName:'',
                results:[]
            }
        },
        methods:{
            searchCity: function(){
                var city = this.cityName
                this.$http.get('http://localhost:9292/api/city',{params:{'city': city}}).then(function(data){
                    var parsed = JSON.parse(data.body)
                    this.results = parsed['citys']
                }),(promise)=>{
                    console.log(promise)
                }
            },
            addCity: function(city){
                var param = {'city': city, 'curr_user': this.$store.state.current_user}
                this.$http.put('http://localhost:9292/api/update_favorites', param).then(function(data){
                   this.$store.commit('setFavorites', JSON.parse(data.body))
                }),(promise)=>{
                    console.log(false)
                }
            }

        },
    }
</script>
<style>
  modal-mask {
  position: center;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  display: table;
  transition: opacity .3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: center;
}

.modal-container {
  width: 600px;
  margin-left: 15px;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
  transition: all .3s ease;
  font-family: Helvetica, Arial, sans-serif;
}

.modal-header h3 {
  margin-top: 0;
  color: #42b983;
}

.modal-body {
  margin: 20px 0;
  width: 100%;
}

.modal-default-button {
  float: right;
}

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>
