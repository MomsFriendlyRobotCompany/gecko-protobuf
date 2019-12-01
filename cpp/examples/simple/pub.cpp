/**************************************************\
* The MIT License (MIT)
* Copyright (c) 2014 Kevin Walchko
* see LICENSE for full details
\**************************************************/

#include <iostream>
#include <gecko/gecko.hpp>
#include <gecko-protobuf/gecko_pb.h>
#include <vector>


using namespace std;
using namespace gecko;
using namespace geckopb;


int main(void){
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    gecko::init();
    try {
        HostInfo host;
        Publisher p;
        p.bind(zmqUDS("/tmp/simple-uds"));

        Rate r(1);

        while(gecko::ok()){
            Vector v;
            v.set_x(1.0);
            v.set_y(-0.00001);
            v.set_z(1000000.0);

            zmq::message_t msg = protobufPack<Vector>(v);

            p.publish(msg);
            // cout << ">> [PUB] sent msg[" << s.size() << "]: " << s << endl;
            cout << v.DebugString() << endl;
            r.sleep();
        }
    }
    catch(zmq::error_t& e) {
        cout << e.what() << endl;
        // exit(1);
    }

    cout << ">> pub bye ...\n" << endl;

    google::protobuf::ShutdownProtobufLibrary();
    return 0;
}
