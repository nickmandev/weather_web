<template>
    <div>
        <div class="panel panel-default well" v-show="this.$store.state.favorites">
            <div class="panel-heading">
                <h3 class="panel-title">Favorites</h3>
            </div>
            <ul class="list-group">
                <li class="list-group-item" v-for="fav in this.$store.state.favorites">
                    {{fav.name}}
                    <button class="glyphicon glyphicon-remove btn-defaut pull-right" @click="removeCity(fav)">

                    </button>
                </li>
            </ul>
            <div class="panel-footer">
                <button class="btn btn-default" @click="modal">Add City</button>

            </div>
            <modal v-if="showModal" @close="showModal = false">
            </modal>
        </div>
    </div>
</template>
<style>
</style>
<script>
import auth from '../auth/auth.js'
import Modal from '../components/Modal.vue'
export default{
    name: "manage-favorites",
    data: function(){
        return{
            showModal:false
        }
    },
    methods:{
        removeCity: function(obj){
            var user_id = this.$store.state.current_user['id']
            this.$http.delete('http://localhost:9292/api/remove_favorite',
            {params:{"id":obj['city_id'], "user_id": user_id}}, {emulateJSON: true}).then(function(data){
                this.$store.commit('setFavorites', JSON.parse(data.body))
            }),(response)=>{
                console.log("fail")
            }
        },
        modal(){
            this.showModal = true
            console.log(this.showModal)
        },

    },
    watch: {
        favId: function(){
            console.log(this.favId)
        }

    },
    components:{
        Modal

    }

}
</script>
