<aura:application >
    <aura:dependency resource="c:helloComponent"/>
    <!-- Load the navigation events in the force namespace. -->
    <aura:dependency resource="markup://force:*" type="EVENT"/>
    <c:helloComponent/>
</aura:application>