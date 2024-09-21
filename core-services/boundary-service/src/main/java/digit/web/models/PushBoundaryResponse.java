package digit.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.Valid;
import lombok.Builder;
import org.egov.common.contract.response.ResponseInfo;

import java.util.List;

@Builder
public class PushBoundaryResponse
{
    @JsonProperty("ResponseInfo")
    @Valid
    private ResponseInfo responseInfo = null;

    private List<String> message;
}
