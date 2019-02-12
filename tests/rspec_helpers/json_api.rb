# frozen_string_literal: true

module Tests
  module RSpecHelpers
    # json api matchers
    module JSONApi
      # custom matchers
      # :reek:UtilityFunction
      module Matchers
        def self.combine_respond_with(name, method)
          send(:define_method, "respond_with_json_#{name}") do |obj|
            respond_with_json.that public_send(method, obj)
          end
        end

        def eq_json_attributes(obj)
          include('data' => include('attributes' => eq(Arguments.prepare(obj))))
        end

        def eq_json_id(obj)
          include('data' => include('id' => eq(Arguments.prepare(obj))))
        end

        def include_json_attributes(obj)
          include('data' => include('attributes' => include(Arguments.prepare(obj))))
        end

        def include_one_with_json_attributes(obj)
          include('data' => include(include('attributes' => include(Arguments.prepare(obj)))))
        end

        def include_json_error(obj)
          include('errors' => include(include(Arguments.prepare(obj))))
        end

        def include_json_links(obj)
          include('data' => include('links' => include(Arguments.prepare(obj))))
        end

        def include_json_relationships(obj)
          include('data' => include('relationships' => include(Arguments.prepare(obj))))
        end

        def include_json_included_of(type)
          include('included' => include(include('type' => type)))
        end

        # rubocop:disable Naming/PredicateName
        def have_json_objects(obj)
          include('data' => have(obj).items)
        end
        # rubocop:enable Naming/PredicateName

        combine_respond_with :attributes_including, :include_json_attributes
        combine_respond_with :attributes_eq, :eq_json_attributes
        combine_respond_with :id_eq, :eq_json_id
        combine_respond_with :error_including, :include_json_error
        combine_respond_with :links_including, :include_json_links
        combine_respond_with :relationships_including, :include_json_relationships
        combine_respond_with :including_one_with_attributes, :include_one_with_json_attributes
        combine_respond_with :objects, :have_json_objects
        combine_respond_with :included_of, :include_json_included_of

        # utiliy module to prepare arguments
        module Arguments
          def self.prepare(obj)
            obj = obj.stringify_keys if obj.is_a?(Hash)
            obj
          end
        end
      end

      include Matchers
    end
  end
end
