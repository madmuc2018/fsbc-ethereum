pragma solidity ^0.4.0;

contract Greetingsv1 {
    string public greeting;

    function Greeter() {
        greeting = 'Hello';
    }

    function setGreeting(string _greeting) public {
        greeting = _greeting;
    }

    function getGreeting() constant returns (string) {
        return greeting;
    }
}