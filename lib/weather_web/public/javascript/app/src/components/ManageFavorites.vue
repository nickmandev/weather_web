<template>
    <div>
        <div class="panel panel-default well" v-show="this.$store.state.favorites">
            <div class="panel-heading">
                <h3 class="panel-title">Favorites</h3>
            </div>
            <ul class="list-group">
                <li class="list-group-item" v-for="fav in this.$store.state.favorites">
                    {{fav.name}}  <input type="checkbox" v-model="favId" :value="fav.city_id" v-if="remove">
                </li>
            </ul>
            <div class="panel-footer">
                <button class="btn btn-default" @click="searchModal"> Add City </button>
                <button class="btn btn-default" @click="toggleRemove"> Remove City </button>
            </div>
            <div class="alert alert-warning" v-if="favId.length">
                <span> Are you sure you want to remove {{ favId.length}} city/s ?</span>
                <button class="btn btn-warning" @click="removeCity"  v-if="favId.length"> Remove</button>
            </div>
        </div>
    </div>
</template>
<style>
</style>
<script>
import auth from '../auth/auth.js'

export default{
    name: "manage-favorites",
    data: function(){
        return{
            favId: [],
            remove: false
        }
    },
    methods:{
        removeCity(){
            this.$http.delete('http://localhost:9292/api/remove_favorite', {params:{"ids":this.favId}}, {emulateJSON: true}).then(function(data){
                console.log("true")
            }),(response)=>{
                console.log("fail")
            }
        },
        toggleRemove(){
            this.remove = !this.remove
            console.log(this.remove)
        },
        searchModal(){
            console.log("Search Modal pressed")
        }
    },
    watch: {
        favId: function(){
            console.log(this.favId)
        }

    }

}
</script>
