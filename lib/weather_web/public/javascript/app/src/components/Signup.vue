<template>
    <div>
        <div v-if="error">
            <h5> {{error}} </h5>
        </div>

    </div>
</template>
<script>
    import auth from '../auth/auth'
    export default{
        data(){
            return{
                credentials: {
                    username:'',
                    password:'',
                    confPassword:''
                },
                error: ''
            }
        },
        methods:{



        }
    }
</script>
