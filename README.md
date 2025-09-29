# I²C Address Translator on an FPGA

Ever have two I²C devices that come with the same exact address? It's like having two people in a room with the same name—you can't talk to just one! This FPGA project acts as a smart receptionist to solve that exact problem.

### What it Does

Instead of letting the address conflict happen, the FPGA steps in the middle. It assigns a unique "virtual" address to each device, so the master can call them by their new, unique names.

In short, the FPGA:
* Listens to the main I²C master (as a slave).
* Talks to the physical devices (as a master).
* Routes the conversation to the correct device based on the virtual address.

The whole process is managed by a simple state machine that reliably handles the I²C protocol from start to stop.

### See it in Action

You can run the simulation and check out the code yourself right here:

 **[Test on EDA Playground](https://www.edaplayground.com/x/6ggJ)**

### Future Ideas

This design currently handles two devices, but the concept could easily be expanded to manage a whole crowd of them!

---
### Acknowledgements

A special thank you to the Vicharak recruitment team for providing the opportunity to work on this interesting design challenge.
