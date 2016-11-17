<template>
    <div id='signup'>
        <h4>Enter Username and a Password longer than 6 symbols.To create an account </h4>
        <div class="row-fluid">
            <div class="col-xs-3">
                <div class="form-group">
                    <label class="text-center" for="acc">Username</label>
                    <input class="form-control" id="acc" type="text" v-model="username">
                    <label class="text-center" for="pass">Password</label>
                    <input class="form-control" id="pass" type="password" v-model="password">
                    <label class="text-center" for="pass_conf">Password Confirmation</label>
                    <input class="form-control" id="pass_conf" type="password_conf" v-model="password_confirmation">
                    <button class="btn btn-primary" type="submit">SignUP</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default{
    name: "signup",
    data: function(){
        return{
            username: "",
            password: "",
            password_confirmation: ""
            }
        }
}
</script>