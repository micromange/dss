package eu.europa.esig.dss.xades.signature;

import eu.europa.esig.dss.diagnostic.DiagnosticData;
import eu.europa.esig.dss.diagnostic.SignatureWrapper;
import eu.europa.esig.dss.diagnostic.jaxb.XmlDigestMatcher;
import eu.europa.esig.dss.enumerations.DigestAlgorithm;
import eu.europa.esig.dss.enumerations.MimeTypeEnum;
import eu.europa.esig.dss.enumerations.SignatureLevel;
import eu.europa.esig.dss.enumerations.SignaturePackaging;
import eu.europa.esig.dss.model.DSSDocument;
import eu.europa.esig.dss.model.FileDocument;
import eu.europa.esig.dss.model.InMemoryDocument;
import eu.europa.esig.dss.signature.DocumentSignatureService;
import eu.europa.esig.dss.spi.DSSUtils;
import eu.europa.esig.dss.utils.Utils;
import eu.europa.esig.dss.xades.DSSObject;
import eu.europa.esig.dss.xades.XAdESSignatureParameters;
import eu.europa.esig.dss.xades.XAdESTimestampParameters;
import eu.europa.esig.dss.xades.reference.Base64Transform;
import eu.europa.esig.dss.xades.reference.CanonicalizationTransform;
import eu.europa.esig.dss.xades.reference.DSSReference;
import eu.europa.esig.dss.xades.reference.EnvelopedSignatureTransform;
import org.junit.jupiter.api.BeforeEach;

import javax.xml.crypto.dsig.CanonicalizationMethod;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class XAdESLevelBEnvelopedDataObjectFormatDefaultTest extends AbstractXAdESTestSignature {

    private DocumentSignatureService<XAdESSignatureParameters, XAdESTimestampParameters> service;
    private XAdESSignatureParameters signatureParameters;
    private DSSDocument documentToSign;

    @BeforeEach
    public void init() throws Exception {
        documentToSign = new FileDocument("src/test/resources/sample.xml");

        signatureParameters = new XAdESSignatureParameters();
        signatureParameters.bLevel().setSigningDate(new Date());
        signatureParameters.setSigningCertificate(getSigningCert());
        signatureParameters.setCertificateChain(getCertificateChain());
        signatureParameters.setSignaturePackaging(SignaturePackaging.ENVELOPED);
        signatureParameters.setSignatureLevel(SignatureLevel.XAdES_BASELINE_B);
        signatureParameters.setReferenceDigestAlgorithm(DigestAlgorithm.SHA512);

        DSSReference envelopedReference = new DSSReference();
        envelopedReference.setId("r-enveloped");
        envelopedReference.setUri("");
        envelopedReference.setDigestMethodAlgorithm(DigestAlgorithm.SHA256);
        envelopedReference.setContents(documentToSign);
        envelopedReference.setTransforms(Arrays.asList(new EnvelopedSignatureTransform(),
                new CanonicalizationTransform(CanonicalizationMethod.EXCLUSIVE)));

        DSSDocument envelopingDocToSign = new FileDocument("src/test/resources/sample.png");

        DSSReference envelopingReference = new DSSReference();
        envelopingReference.setId("r-obj");
        envelopingReference.setType("http://www.w3.org/2000/09/xmldsig#Object");
        envelopingReference.setUri("#obj");
        envelopingReference.setDigestMethodAlgorithm(DigestAlgorithm.SHA512);
        envelopingReference.setContents(envelopingDocToSign);
        envelopingReference.setTransforms(Collections.singletonList(new Base64Transform()));

        signatureParameters.setReferences(Arrays.asList(envelopedReference, envelopingReference));

        DSSDocument objectContent = new InMemoryDocument(Utils.toBase64(DSSUtils.toByteArray(envelopingDocToSign)).getBytes());

        DSSObject object = new DSSObject();
        object.setId("obj");
        object.setMimeType(MimeTypeEnum.PNG.getMimeTypeString());
        object.setEncodingAlgorithm(new Base64Transform().getAlgorithm());
        object.setContent(objectContent);
        envelopingReference.setObject(object);

        service = new XAdESService(getOfflineCertificateVerifier());
    }

    @Override
    @SuppressWarnings({ "unchecked" })
    protected void checkMessageDigestAlgorithm(DiagnosticData diagnosticData) {
        SignatureWrapper signature = diagnosticData.getSignatureById(diagnosticData.getFirstSignatureId());
        List<XmlDigestMatcher> digestMatchers = signature.getDigestMatchers();
        assertTrue(Utils.isCollectionNotEmpty(digestMatchers));

        int sha256Counter = 0;
        int sha512Counter = 0;
        for (XmlDigestMatcher xmlDigestMatcher : digestMatchers) {
            if (DigestAlgorithm.SHA256.equals(xmlDigestMatcher.getDigestMethod())) {
                ++sha256Counter;
            } else if (DigestAlgorithm.SHA512.equals(xmlDigestMatcher.getDigestMethod())) {
                ++sha512Counter;
            }
        }
        assertEquals(1, sha256Counter);
        assertEquals(2, sha512Counter);
    }

    @Override
    protected DocumentSignatureService<XAdESSignatureParameters, XAdESTimestampParameters> getService() {
        return service;
    }

    @Override
    protected XAdESSignatureParameters getSignatureParameters() {
        return signatureParameters;
    }

    @Override
    protected DSSDocument getDocumentToSign() {
        return documentToSign;
    }

    @Override
    protected String getSigningAlias() {
        return GOOD_USER;
    }

}
