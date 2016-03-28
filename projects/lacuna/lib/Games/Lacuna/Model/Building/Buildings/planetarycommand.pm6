
use Games::Lacuna::Model::Building::BuildingRole;

class Games::Lacuna::Model::Building::Buildings::planetarycommand does Games::Lacuna::Model::Building::BuildingRole {
    use Games::Lacuna::Exception;

    method view() {
        ### I want to be able to call PARENT.view(), but can't figure out how 
        ### to do that, so I've had to rename the method to "role_view" in the 
        ### BuildingRole.
        ###
        ### PCC gets an additional 'planet' hash added to the view.
        ### https://us1.lacunaexpanse.com/api/PlanetaryCommand.html#view_%28_session_id%2C_building_id_%29
        my %rv = $.role_view;
        say %rv.keys;
    }
    method view_plans( --> Array ) {#{{{
        use Games::Lacuna::Model::Plan;
        my %rv = $.account.send(
            :endpoint_name($.type), :method('view_plans'),
            [$.account.session_id, $.id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        my @a = %rv<result><plans>.map({ Games::Lacuna::Model::Plan.new(:json($_)) });
    }#}}}
    method view_incoming_supply_chains( --> Array ) {#{{{
        use Games::Lacuna::Model::SupplyChain;
        my %rv = $.account.send(
            :endpoint_name($.type), :method('view_incoming_supply_chains'),
            [$.account.session_id, $.id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        my @a = %rv<result><supply_chains>.map({ Games::Lacuna::Model::SupplyChain.new(:json($_)) });
    }#}}}

    ### I'm getting error -32601 "Method not found" back from the server for 
    ### this.  It's documented, and spelled correctly here, but still doesn't 
    ### work.  I also see no way to call this from within the game GUI itself, 
    ### so I'm guessing it doesn't work.
    method subsidize_pod_cooldown(--> Bool) {#{{{
        my %rv = $.account.send(
            :endpoint_name($.type), :method('subsidize_pod_cooldown'),
            [$.account.session_id, $.id]
        );
        die Games::Lacuna::Exception.new(%rv) if %rv<error>;
        ### return from the server is the same as for view(), which I don't 
        ### care about.
        True;
    }#}}}

}

