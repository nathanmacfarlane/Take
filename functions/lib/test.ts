interface OwnerRoute {
    [owner: string]: [string];
}

var old = OwnerRoute();
old['nate'] = ['route1', 'route2'];

var new = OwnerRoute();
new['john'] = ['route3', 'route4'];
