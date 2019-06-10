public class Var {
    public void m() { 
        TokenRenewer samlTokenRenewer = new SAMLTokenRenewer();
        samlTokenRenewer.setVerifyProofOfPossession(false);
        samlTokenRenewer.setAllowRenewalAfterExpiry(true);
        ((SAMLTokenRenewer)samlTokenRenewer).setMaxExpiry(1L);
    }
}
