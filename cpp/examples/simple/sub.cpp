/**************************************************\
* The MIT License (MIT)
* Copyright (c) 2014 Kevin Walchko
* see LICENSE for full details
\**************************************************/

#include <iostream>
#include <gecko/gecko.hpp>
#include <gecko-protobuf/gecko_pb.h>

using namespace std;
using namespace gecko;
using namespace geckopb;


int main(int argc, char *argv[]){
    gecko::init();

    try {
        Subscriber s;
        s.connect(zmqUDS("/tmp/simple-uds"));
        Rate r(40);

        while(gecko::ok()){
            zmq::message_t msg = s.recv_nb();
            if(msg.size() > 0){
                Vector v = protobufUnpack<Vector>(msg);
                cout << v.DebugString() << endl;
            }
            r.sleep();
        }
    }
    catch(zmq::error_t& e) {
        cout << e.what() << endl;
        exit(1);
    }

    cout << ">> sub bye\n" << endl;

    return 0;
}
