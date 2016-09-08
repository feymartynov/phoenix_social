import {IndexRoute, Route} from 'react-router';
import React from 'react';
import MainLayout from '../layouts/main';
import HelloWorld from '../components/hello_world';

export default function configRoutes(store) {
    return (
        <Route component={MainLayout}>
            <Route path="/" component={HelloWorld}>
            </Route>
        </Route>
    );
}
