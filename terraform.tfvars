subnet_prefix = "10.0.200.0/24"


variable "var_name" {
    description = ""
    default = ""
    type = ""
}

#A string variable:

variable "firststring" {
    type = "string"
    defualt = "this is my first string"
}

output "myfirstoutput" {
    value = "${var.firststring}"
}


variable "multilinestring" {
    type = "string"
    default = <<EOH
    this is a multiline string
    new line
    EOH
}

output "multilinestring" {
    value = "${var.multilinestring}"
}


#Maps example:

variable "mapexample"{
	type = "map"
	default = {
		"useast" = "ami-1"
		"euwest" = "ami-2"
	}
}

output "mapoutput" {
    value = "${var.mapexample["useast"]}"
}

#Lists example:

variable "mysecuritygrouplist" {
    type = "list"
    default = ["sg1", "sg2", "sg3", "sg4"]
}

output "sgoutput" {
    value = "${var.mysecuritygrouplist[0]}"
}

#Boolean Example:

variable "testbool" {
    deafult = true
}

output "booloutput" {
    value = "${var.testbool}"
}
#booloutput = 1 if true
#booloutput = 0 if false

#Output a variable:
variable "myinputvariable" {
	type = "string"
}

output "myoutputvariable" {
	value = "${var.myinputvariable}"
}

#Assign value to a variable via the command line:
#terraform apply -var "var_name = value"