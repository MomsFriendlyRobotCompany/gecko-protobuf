# Google Protocol Buffer for Gecko C++

## Install

1. clone repo
1. `cd cpp`
1. `./build_extlibs.sh`
1. `mkdir build`
1. `cmake ..`
1. `make install`
1. `export LD_LIBRARY_PATH=/opt/gecko/lib:/opt/gecko/gecko/lib:$LD_LIBRARY_PATH`

# Examples

## Publisher

```cpp
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
```

## Subscriber

```cpp
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
```
