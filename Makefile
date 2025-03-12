protoc:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.32
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3

	export PATH="$PATH:$(go env GOPATH)/bin"

	protoc \
	--proto_path=proto --go_out=proto --go_opt=paths=source_relative \
    --go-grpc_out=proto --go-grpc_opt=paths=source_relative \
    weather-station.proto