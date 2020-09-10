({
init: function (cmp, event, helper) {
var myBreadcrumbs = [
{label: 'Account', name: 'record1' },
{label: 'Contact', name: 'record2' },
{label: 'Opportunity', name: 'record3' },
{label: 'Case', name: 'record4' },
{label: 'Asset', name: 'record5' },
{label: 'Order', name: 'record6' }    
];
cmp.set('v.myBreadcrumbs', myBreadcrumbs);
},
navigateTo: function (cmp, event, helper) {
//get the name of the breadcrumb that's clicked
var name = event.getSource().get('v.name');
    
alert(name);    
}})