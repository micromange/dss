package eu.europa.esig.dss.xades;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class XAdESIdPrefixTest {

  @Test
  void getDefaultPrefixes() {
    XAdESIdPrefixes prefix = XAdESIdPrefixes.newBuilder().build();
    assertEquals("id-", prefix.getId());
    assertEquals("ets-", prefix.getEncapsulatedTimestamp());
    assertEquals("ts-", prefix.getTimestamp());
    assertEquals("keyInfo-", prefix.getKeyInfo());
    assertEquals("xades-", prefix.getXades());
    assertEquals("value-", prefix.getValue());
  }

  @Test
  void getChangedPrefixes() {
    XAdESIdPrefixes prefix =
        XAdESIdPrefixes.newBuilder()
            .id("otherid-")
            .encapsulatedTimestamp("otherets-")
            .timestamp("otherts-")
            .keyInfo("otherkeyInfo-")
            .xades("otherxades-")
            .value("othervalue-")
            .build();
    assertEquals("otherid-", prefix.getId());
    assertEquals("otherets-", prefix.getEncapsulatedTimestamp());
    assertEquals("otherts-", prefix.getTimestamp());
    assertEquals("otherkeyInfo-", prefix.getKeyInfo());
    assertEquals("otherxades-", prefix.getXades());
    assertEquals("othervalue-", prefix.getValue());
  }

  @Test
  void getPrefixesNeedsToBeUnique() {
    assertThrows(
        IllegalArgumentException.class,
        () ->
            XAdESIdPrefixes.newBuilder()
                .id("otherid-")
                .encapsulatedTimestamp("otherets-")
                .timestamp("other-")
                .keyInfo("other-")
                .xades("otherxades-")
                .value("othervalue-")
                .build());
  }

	@ParameterizedTest
	@ValueSource(strings = { "<id-", ">id-", "&id-", "\"id-", "'id-" })
	void getPrefixesContainsIllegalXmlCharacters(String id) {
		assertThrows(
				IllegalArgumentException.class,
				() ->
						XAdESIdPrefixes.newBuilder()
								.id(id)
								.build(),"Id contains invalid XML character: " + id);
	}
}
