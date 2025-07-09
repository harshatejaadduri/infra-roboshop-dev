variable "components" {
    default = {
        catalogue = {
            priority_rule = 10
        }
        user = {
            priority_rule = 20
        }
        cart = {
            priority_rule = 30
        }
        shipping = {
            priority_rule = 40
        }
        payment = {
            priority_rule = 50
        }
        frontend = {
            priority_rule = 10
        }
    }
}