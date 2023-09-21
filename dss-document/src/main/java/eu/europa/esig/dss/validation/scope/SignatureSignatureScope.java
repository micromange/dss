package eu.europa.esig.dss.validation.scope;

import eu.europa.esig.dss.enumerations.SignatureScopeType;
import eu.europa.esig.dss.model.DSSDocument;
import eu.europa.esig.dss.model.identifier.DataIdentifier;
import eu.europa.esig.dss.model.identifier.TokenIdentifierProvider;
import eu.europa.esig.dss.model.scope.SignatureScope;
import eu.europa.esig.dss.validation.AdvancedSignature;

import java.util.Objects;

/**
 * Defines a signature scope covering a signature
 *
 */
public class SignatureSignatureScope extends SignatureScope {

    /**
     * Covered signature
     */
    private final AdvancedSignature signature;

    /**
     * Default constructor to create a signature scope
     *
     * @param signature {@link AdvancedSignature}
     * @param document {@link DSSDocument} representing the covered signature document (NOTE: not necessary to be a signature file)
     */
    public SignatureSignatureScope(final AdvancedSignature signature, final DSSDocument document) {
        super(signature.getId(), document);
        Objects.requireNonNull(signature, "Signature shall be provided!");
        this.signature = signature;
    }

    @Override
    public DataIdentifier getDSSId() {
        return super.getDSSId();
    }

    @Override
    public String getName(TokenIdentifierProvider tokenIdentifierProvider) {
        return getSignatureId(tokenIdentifierProvider);
    }

    @Override
    public String getDescription(TokenIdentifierProvider tokenIdentifierProvider) {
        return String.format("Signature with Id : %s", getSignatureId(tokenIdentifierProvider));
    }

    private String getSignatureId(TokenIdentifierProvider tokenIdentifierProvider) {
        return tokenIdentifierProvider.getIdAsString(signature);
    }

    @Override
    public SignatureScopeType getType() {
        return SignatureScopeType.SIGNATURE;
    }

}
