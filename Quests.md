# Ch1 Day 1

## Explain what the Blockchain is in your own words.

a blockchain is a distributed network where information can be stored publicly. Users can interact with that information without restriction from centralized authorities. Blockchains typically have certain properties to protect users from scams and fordgery. Inheritly, blockchains allow for users to rely on distributed programming consensus (Math) instead of trusted (centralized) third parties, without compromosing security.

## Explain what a Smart Contract is.

a smart contract is logic deployed to the blockchain that allows users to change the state of data stored on the blockchain.

## Explain the difference between a script and a transaction.

a script allows a user to read information on the blockchain while a transaction allows users to create, update, or delete information on the blockchain. A transaction typically has fees associated with its execution in the form of the blockchains native token. These "gas fees" serve as an incentive to the validators who mantain the integrity of the network.

# Ch1 Day 2

## What are the 5 Cadence Programming Language Pillars?

    Safety and Security
    Clarity
    Approachability
    Developer Experience
    Resource Oriented Programming

## In your opinion, even without knowing anything about the Blockchain or coding, why could the 5 Pillars be useful (you don't have to answer this for #5)?

    Of course safety ad security are always top priority bc people value the rights and property.

    Clarity is important to allow other to easily understand and work on your code, code that only you understand limits the development of your code, because then only you can contribute.

    Approachability allows for devs to quickly pickup on a language. Shortening the learning process allows removes a barrier to entry and allows for a growing community, in hopes to make the project a standard.

    Dev Exp: Devs like easy to debug and understand languages. A balance of control, yet not too much typing is always ideal.

# Ch2 Day 1

### Deploy a contract to account 0x03 called "JacobTucker". Inside that contract, declare a constant variable named is, and make it have type String. Initialize it to "the best" when your contract gets deployed.

### Check that your variable is actually equals "the best" by executing a script to read that variable. Include a screenshot of the output.

![First Smart Contract](First-Smart-Contract.png)

# Ch2 Day 2

## 1.) Explain why we wouldn't call changeGreeting in a script.

changeGreeting changes the state of the greeting variable in the smart contract. Scripts do not change the state of variables in smart contracts, this functionality is exclusive to transactions.

## 2.) What does the AuthAccount mean in the prepare phase of the transaction?

the AuthAccount is the parameter taken into the prepare phase of the transaction. This AuthAccount approves the transaction ("signs it") and pays the gas fees to execute the transaction.

## 3.) What is the difference between the prepare phase and the execute phase in the transaction?

the prepare phase access the data in the account, like a gatekeeper to approve the manipulation of resources. The execute phase can not access data in the account, but it can call functions to actually do the manipulation of the data on the blockchain, after everything checks out in the prepare phase.

## 4.) Add two new things inside your contract:

- 1.) A variable named myNumber that has type Int (set it to 0 when the contract is deployed)

- 2.) A function named updateMyNumber that takes in a new number named newNumber as a parameter that has type Int and updates myNumber to be newNumber

  - Add a script that reads myNumber from the contract

  - Add a transaction that takes in a parameter named myNewNumber and passes it into the updateMyNumber function. Verify that your number changed by running the script again.

![First Transaction](First-Transaction.png)

# Ch2 Day 3 - Arrays, Dictionaries, and Optionals

### 1) In a script, initialize an array (that has length == 3) of your favourite people, represented as Strings, and log it.

### 2) In a script, initialize a dictionary that maps the Strings Facebook, Instagram, Twitter, YouTube, Reddit, and LinkedIn to a UInt64 that represents the order in which you use them from most to least. For example, YouTube --> 1, Reddit --> 2, etc. If you've never used one before, map it to 0!

![Array&Dict](Array&Dict.png)

### 3) Explain what the force unwrap operator "!" does, with an example different from the one I showed you (you can just change the type).

the force unwrap operator changes the type from a type optional (ex Bool?) to just the type (Bool)

### 4) Using this picture below, explain...

- What the error message means

  - the error message means the compiler was expecting a type optional (String or nil) but got the type (String)

- Why we're getting this error

  - we're getting this error because the value of "thing[0x03]" is a String not a String optional which is the default value in dictionaries

- How to fix it

  - the way to fix this, is to force unwrap the return value by adding the force unwrap operator "thing[0x03]!"

# Ch2 Day 4 - Basic Structs

## Typo Alert! #5 on Real example inititialize a dictionary - not an array :)

1.  Deploy a new contract that has a Struct of your choosing inside of it (must be different than Profile).

2.  Create a dictionary or array that contains the Struct you defined.

3.  Create a function to add to that array/dictionary.

        access(all) contract Dealership {

            pub var cars: {Address: Car}

            pub struct Car {
                pub let make: String
                pub let model: String
                pub let year: String
                pub let account: Address

                init(_make: String, _model: String, _year: String, _account: Address){
                self.make = _make
                self.model = _model
                self.year = _year
                self.account = _account
                }

            }

            pub fun addCar(make: String, model: String, year: String, account: Address){
                let newCar = Car(_make:make, _model:model, _year:year, _account:account)
                self.cars[account] = newCar
            }

            init() {
                self.cars = {}
            }
        }

4.  Add a transaction to call that function in step 3.

        import Dealership from 0x02

        transaction(make: String, model: String, year: String, account: Address) {
            prepare(signer: AuthAccount) {}

            execute {
            Dealership.addCar(make: make, model: model, year: year, account: account)
            }
        }

5.  Add a script to read the Struct you defined.

        import Dealership from 0x02

        pub fun main(account: Address): Dealership.Car {
            return Dealership.cars[account]!
        }

# Ch3 Day 1 - Intro to Resources

1.  In words, list 3 reasons why structs are different from resources.

    - Structs can be overwritten, copied, and created anytime. Resources can not be overwritten or copied and must be accounted for at all times.

2.  Describe a situation where a resource might be better to use than a struct.

    - An NFT is the perfect situation. To be more specific, the title of a car would be a good resource.

3.  What is the keyword to make a new resource?

    - Create

4.  Can a resource be created in a script or transaction (assuming there isn't a public function to create one)?

    - Definetly not a script because scripts can only view data. Transactions can create resources.

5.  What is the type of the resource below?

    - @Jacob

6.  Let's play the "I Spy" game from when we were kids. I Spy 4 things wrong with this code. Please fix them.

        pub contract Test {

            pub resource Jacob {
                pub let rocks: Bool
                init() {
                    self.rocks = true
                }
            }

            pub fun createJacob(): @Jacob {
                let myJacob <- create Jacob()
                return <- myJacob
            }

        }

# Ch 3 Day 2 - Resources in Dictionaries & Arrays
