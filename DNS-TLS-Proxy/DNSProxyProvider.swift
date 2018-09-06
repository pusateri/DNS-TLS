//
//  DNSProxyProvider.swift
//  DNS-TLS-Proxy
//
//  Created by Tom Pusateri on 6/23/17.
//  Copyright © 2017 !j. All rights reserved.
//

import NetworkExtension

class DNSProxyProvider: NEDNSProxyProvider {
    var context: OpaquePointer?

    override func startProxy(options:[String: Any]? = nil, completionHandler: @escaping (Error?) -> Void) {
#if notyet
        var r: getdns_return_t;

        r = getdns_context_create(&context, 1)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_create failed with error code: \(r)")
            return
        }
#endif
        /*
        if let config = options?["config"] as? String {
            
            var config_dict: OpaquePointer?

            r = getdns_str2dict(config, &config_dict)
            if (r != GETDNS_RETURN_GOOD) {
                NSLog("Config from options dictionary not a valid string")
                return
            }
            
            r = getdns_context_config(context, config_dict)
            if (r != GETDNS_RETURN_GOOD) {
                NSLog("getdns_context_config failed with error code: \(r)")
                return
            }
            getdns_dict_destroy(config_dict)
        } else {
            NSLog("Config from options dictionary not a valid string")
            return
        }
        config["idle_timeout"] = self.idle_timeout
        */
#if notyet
        r = getdns_context_set_resolution_type(context, GETDNS_RESOLUTION_STUB)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_resolution_type failed with error code: \(r)")
            return
        }
        var transport: getdns_transport_list_t = GETDNS_TRANSPORT_TLS
        r = getdns_context_set_dns_transport_list(context, 1, &transport)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_dns_transport_list failed with error code: \(r)")
            return
        }
        
        r = getdns_context_set_tls_authentication(context, GETDNS_AUTHENTICATION_REQUIRED)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_tls_authentication failed with error code: \(r)")
            return
        }

        r = getdns_context_set_round_robin_upstreams(context, 1)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_round_robin_upstreams failed with error code: \(r)")
            return
        }

        r = getdns_context_set_edns_client_subnet_private(context, 1)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_edns_client_subnet_private failed with error code: \(r)")
            return
        }

        r = getdns_context_set_tls_query_padding_blocksize(context, 1)
        if (r != GETDNS_RETURN_GOOD) {
            NSLog("getdns_context_set_tls_query_padding_blocksize failed with error code: \(r)")
            return
        }

        r = getdns_context_set_idle_timeout(context, 10000)
        getdns_context_run(context);
#endif
        completionHandler(nil)
        NSLog("DNSTLS: startProxy")
    }
    
    override func stopProxy(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
#if notyet
        getdns_context_destroy(context);
#endif
        completionHandler()
        NSLog("DNSTLS: stopProxy")
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
        NSLog("DNSTLS: sleep")
    }
    
    override func wake() {
        NSLog("DNSTLS: wake")
        // Add code here to wake up.
    }
    
    override func handleNewFlow(_ flow: NEAppProxyFlow) -> Bool {
        
        NSLog("DNSTLS: handleNewFlow from \(flow.metaData.sourceAppUniqueIdentifier): \(flow)")
        // Add code here to handle the incoming flow.
        
        //if([flow isKindOfClass:[NEAppProxyUDPFlow class]]) {
        //}
        /*
        if([flow isKindOfClass:[NEAppProxyUDPFlow class]])
        {
            NSLog(@"UmbrellaExtension: we have a UDP flow.");
            NEAppProxyUDPFlow * udpFlow = (NEAppProxyUDPFlow *) flow;
            NWHostEndpoint * localEndpoint = [NWHostEndpoint endpointWithHostname:@"127.0.0.1" port:@"53"];
            
            [udpFlow openWithLocalEndpoint:nil completionHandler:^(NSError *error){
                if(error == nil)
                {
                [udpFlow readDatagramsWithCompletionHandler:^(NSArray * datagrams, NSArray * endpoints, NSError *error){
        */
        return false
    }
}

