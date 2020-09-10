<aura:application extends="force:slds">
    <c:MainComp/>
    <aura:handler event="c:NavigateToC2" action="{!c.NavigateComponent}"/>
    {!v.body}
</aura:application>